# frozen_string_literal: true

# app/services/url_shortener_service.rb

# Service to validate URL inputs and generate shortened URLs
#
# @param original_url [String] The original URL that needs to be shortened.
#
# @method initialize
# Initializes the service with the original URL to be shortened.
#
# @param original_url [String] The URL to shorten.
# @return [UrlShortenerService] An instance of the UrlShortenerService.
class UrlShortenerService
  def initialize(original_url)
    @original_url = original_url
  end

  # @method shorten
  # Validates the original URL, fetches its title, and creates a new shortened URL record in the database.
  # If successful, it returns the URL object; if an error occurs, it logs the error.
  #
  # @param original_url [String] The original URL to shorten.
  # @return [Url] The shortened URL object.
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

  # @method valid_url?
  # Validates if the original URL has a valid scheme (http or https).
  def valid_url?
    uri = URI.parse(@original_url)
    %w[http https].include?(uri.scheme)
  rescue URI::InvalidURIError
    false
  end

  # @method fetch_title
  # Fetches the title of the original URL by making an HTTP request and parsing the HTML response.
  # If an error occurs, it returns 'No Title'.
  def fetch_title
    uri = URI.parse(@original_url)
    response = Net::HTTP.get(uri)
    Nokogiri::HTML(response).title
  rescue StandardError
    'No Title'
  end

  # @method handle_exception
  # Handles any unexpected errors that occur during URL shortening and adds an error message to the URL object.
  def handle_exception(exception, url)
    log_error("An unexpected error occurred while shortening URL: #{exception.message}")
    url.errors.add(:base, 'An unexpected error occurred while shortening the URL.')
  end

  # @method log_info
  # Logs informational messages to the Rails logger.
  def log_info(message)
    Rails.logger.info(message)
  end

  # @method log_error
  # Logs error messages to the Rails logger.
  def log_error(message)
    Rails.logger.error(message)
  end
end
