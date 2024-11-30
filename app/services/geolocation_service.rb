# frozen_string_literal: true

# app/services/geolocation_service.rb

# Fetches geolocation data for a given IP address using Geocoder
class GeolocationService
  BASE_URL = 'https://ipgeolocation.abstractapi.com/v1/'
  API_KEY = ENV.fetch('ABSTRACT_API_KEY')

  def initialize(ip_address = nil)
    @ip_address = ip_address || request.remote_ip
  end

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

