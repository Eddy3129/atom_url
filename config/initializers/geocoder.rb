Geocoder.configure(
  # Geocoding options
  timeout: 5,
  lookup: :geoapify, # You can choose a different lookup service
  ip_lookup: :geoapify,
  units: :km,
  # API key for the chosen service
  api_key: ENV["GEOLOCATOR_API_KEY"], # Set this in your environment variables
  use_https: true,
  cache: Rails.cache,
  cache_prefix: "geocoder:"
)
