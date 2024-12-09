# frozen_string_literal: true

# Tracks URL visits; geocodes IP addresses to determine location.
class Visit < ApplicationRecord
  belongs_to :url
  # Make sure ip-address exist for each visit
  validates :ip_address, presence: true
  # Use ip address to access geolocation data
  geocoded_by :ip_address
  after_validation :geocode, if: :ip_address_changed?
end
