# lib/geocoder/results/geoapify.rb

module Geocoder
  module Result
    class Geoapify < Base
      # Returns an array with latitude and longitude
      def coordinates
        [data["location"]["lat"], data["location"]["lon"]] if data["location"] && data["location"]["lat"] && data["location"]["lon"]
      end

      # Returns the state
      def state
        data.dig("state", "name")
      end

      # Returns the country
      def country
        data.dig("country", "name")
      end
    end
  end
end
