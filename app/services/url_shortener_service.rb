# frozen_string_literal: true

# app/services/url_shortener_service.rb

# Service to validate URL inputs and generate shortened URLs
class UrlShortenerService
  def initialize(original_url)
    @original_url = original_url
  end

  def shorten
    url = Url.new(original_url: @original_url, title: fetch_title)

    if valid_url? && url.save
      log_info("Successfully created Url: #{url.inspect}")
    else
      log_error("Failed to create Url: #{url.errors.full_messages.join(', ')}")
    end

    url
  rescue StandardError => e
    handle_exception(e, url)
  end

  private

  def valid_url?
    uri = URI.parse(@original_url)
    %w[http https].include?(uri.scheme)
  rescue URI::InvalidURIError
    false
  end

  def fetch_title
    uri = URI.parse(@original_url)
    response = Net::HTTP.get(uri)
    Nokogiri::HTML(response).title
  rescue StandardError
    'No Title'
  end

  def handle_exception(exception, url)
    log_error("An unexpected error occurred while shortening URL: #{exception.message}")
    url.errors.add(:base, 'An unexpected error occurred while shortening the URL.')
  end

  def log_info(message)
    Rails.logger.info(message)
  end

  def log_error(message)
    Rails.logger.error(message)
  end
end
