# frozen_string_literal: true

# Tracks URL visits; geocodes IP addresses to determine location.
class Visit < ApplicationRecord
  belongs_to :url

  validates :ip_address, presence: true

  geocoded_by :ip_address
  after_validation :geocode, if: :ip_address_changed?
end
