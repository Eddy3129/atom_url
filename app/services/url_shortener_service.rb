# app/services/url_shortener_service.rb

class UrlShortenerService
  def initialize(original_url)
    @original_url = original_url
  end

  def shorten
    short_code = generate_unique_short_code
    url = Url.create!(original_url: @original_url, title: fetch_title, short_code: short_code)
    Rails.logger.info "Successfully created Url: #{url.inspect}"
    url
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create Url: #{e.record.errors.full_messages.join(', ')}"
    nil
  rescue StandardError => e
    Rails.logger.error "An unexpected error occurred while shortening URL: #{e.message}"
    nil
  end

  private

  def fetch_title
    uri = URI.parse(@original_url)
    response = Net::HTTP.get(uri)
    Nokogiri::HTML(response).title
  rescue
    'No Title'
  end

  def generate_unique_short_code
    loop do
      code = SecureRandom.alphanumeric(6)
      break code unless Url.exists?(short_code: code)
    end
  end
end
