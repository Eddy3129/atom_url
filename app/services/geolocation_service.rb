# app/services/geolocation_service.rb

class GeolocationService
  require 'geocoder'

  def initialize(ip_address)
    @ip = ip_address
  end

  def fetch_geolocation
    results = Geocoder.search(@ip)
    if results.present?
      result = results.first
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
    else
      { error: "No geolocation data found for IP: #{@ip}" }
    end
  rescue Geocoder::OverQueryLimitError
    { error: "API query limit exceeded" }
  rescue Geocoder::RequestDenied
    { error: "API request was denied" }
  rescue Geocoder::InvalidRequest
    { error: "Invalid geocoding request" }
  rescue StandardError => e
    { error: "An error occurred: #{e.message}" }
  end
end
