# frozen_string_literal: true

# app/services/geolocation_service.rb

# Fetches geolocation data for a given IP address using Abstract API
# @param ip_address [String, nil] The IP address to fetch geolocation data for.
# @return [GeolocationService] An instance of the GeolocationService.
class GeolocationService
  BASE_URL = 'https://ipgeolocation.abstractapi.com/v1/'
  API_KEY = ENV.fetch('ABSTRACT_API_KEY')

  def initialize(ip_address = nil)
    @ip_address = ip_address || request.remote_ip
  end

  # @method fetch_geolocation
  # Fetches the geolocation data by making a request to the AbstractAPI's geolocation endpoint.
  # If the request is successful, it returns the parsed geolocation data; otherwise, it returns an error message.
  #
  # @param ip_address [String] The IP address whose geolocation information needs to be fetched.
  # @return [Hash] A hash containing the geolocation data or an error message.
  def fetch_geolocation
    url = "#{BASE_URL}?api_key=#{API_KEY}&ip_address=#{@ip_address}"

    begin
      response = HTTParty.get(url)
      if response.success?
        parse_geolocation_response(response)
      else
        { error: "Failed to retrieve geolocation data. API responded with status code #{response.code}" }
      end
    rescue StandardError => e
      { error: "Error occurred while fetching geolocation: #{e.message}" }
    end
  end

  private

  #
  # @method parse_geolocation_response
  # Parses the response from the geolocation API and returns the relevant data, including city, state, country, latitude, longitude, and more.
  # If the response contains an error, it returns the error message.
  #
  # @param response [HTTParty::Response] The response object from the API request.
  # @return [Hash] A hash containing geolocation data or an error message if the data is not present.
  def parse_geolocation_response(response)
    data = response.parsed_response
    if data['error'].present?
      { error: data['error']['message'] }
    else
      {
        city: data['city'],
        state: data['region'],
        country: data['country'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        timezone: data['timezone']['name'],
        postal_code: data['postal_code']
      }
    end
  end
end
