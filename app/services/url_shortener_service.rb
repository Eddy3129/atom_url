# app/services/url_shortener_service.rb

class UrlShortenerService
  def initialize(original_url)
    @original_url = original_url
  end

  def shorten
    url = Url.new(original_url: @original_url)

    # Validate the URL format
    unless valid_url?
      url.errors.add(:original_url, "is invalid.")
      return url
    end

    # Generate a unique short_code
    url.short_code = generate_unique_short_code

    # Fetch the title
    url.title = fetch_title

    # Attempt to save the Url object
    if url.save
      Rails.logger.info "Successfully created Url: #{url.inspect}"
      return url
    else
      Rails.logger.error "Failed to create Url: #{url.errors.full_messages.join(', ')}"
      return url
    end
  rescue StandardError => e
    Rails.logger.error "An unexpected error occurred while shortening URL: #{e.message}"
    url.errors.add(:base, "An unexpected error occurred while shortening the URL.")
    return url
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
