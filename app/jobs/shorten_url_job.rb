# frozen_string_literal: true

# Background job for shortening URLs using SideKiq
class ShortenUrlJob < ApplicationJob
  queue_as :default

  def perform(original_url, user_id = nil)
    url_shortener = UrlShortenerService.new(original_url)
    shortened_url = url_shortener.shorten

    Url.create!(
      original_url: original_url,
      short_code: shortened_url.short_code,
      user_id: user_id,
      visit_count: 0
    )
  rescue StandardError => e
    Rails.logger.error "URL Shortening failed: #{e.message}"
  end
end
