# frozen_string_literal: true

Geocoder.configure(
  # Geocoding options
  timeout: 3, # geocoding service timeout (secs)
  lookup: :abstract_api,         # name of geocoding service (symbol)
  ip_lookup: :abstract_api,      # name of IP address geocoding service (symbol)
  language: :en, # ISO-639 language code
  use_https: true, # use HTTPS for lookup requests? (if supported)
  api_key: Rails.application.credentials.ABSTRACT_API_KEY, # API key for geocoding service
  cache: Rails.cache, # cache object (must respond to #[], #[]=, and #del)
  cache_prefix: 'geocoder:'
  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear

  # Cache configuration
  # cache_options: {
  #   expiration: 2.days,
  #   prefix: 'geocoder:'
  # }
)
