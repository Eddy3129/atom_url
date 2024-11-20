# lib/geocoder/lookups/geoapify.rb

require 'geocoder/lookups/base'
require 'geocoder/results/geoapify'

module Geocoder::Lookup
  class Geoapify < Base
    def name
      "Geoapify"
    end

    def query_url(query)
      "#{protocol}://api.geoapify.com/v1/geocode/ip"
    end

    def query_params(query)
      {
        "apiKey" => configuration.api_key,
        "ip" => query.sanitized_text,
        "format" => "json",
        "limit" => 1
      }
    end

    def results(query)
      return [] unless doc = fetch_data(query)
      return [] unless doc["results"]
      doc["results"].map do |result|
        Geocoder::Result::Geoapify.new(result)
      end
    end

    def supported_protocols
      [:http, :https]
    end
  end
end
