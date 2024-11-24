# frozen_string_literal: true

# app/services/geolocation_service.rb

# Fetches geolocation data for a given IP address using Geocoder
class GeolocationService
  require 'geocoder'

  def initialize(ip_address)
    @ip = ip_address
  end

  def fetch_geolocation
    result = geocode_ip
    if result
      extract_geolocation_data(result)
    else
      { error: "No geolocation data found for IP: #{@ip}" }
    end
  rescue StandardError => e
    handle_error(e)
  end

  private

  def geocode_ip
    results = Geocoder.search(@ip)
    results.first if results.present?
  end

  def extract_geolocation_data(result)
    {
      latitude: result.latitude,
      longitude: result.longitude,
      city: result.city,
      state: result.state,
      country: result.country,
      country_code: result.country_code,
      postal_code: result.postal_code,
      timezone: result.time_zone,
      coordinates: result.coordinates
    }
  end

  def handle_error(error)
    case error
    when Geocoder::OverQueryLimitError
      { error: 'API query limit exceeded' }
    when Geocoder::RequestDenied
      { error: 'API request was denied' }
    when Geocoder::InvalidRequest
      { error: 'Invalid geocoding request' }
    else
      { error: "An error occurred: #{error.message}" }
    end
  end
end
