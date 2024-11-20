class Visit < ApplicationRecord
  belongs_to :url

  # Geocode based on IP address
  geocoded_by :ip_address

  # Automatically geocode after validation if ip_address has changed
  after_validation :geocode, if: :will_save_change_to_ip_address?

  private

  def geocode
    return unless ip_address.present?

    results = Geocoder.search(ip_address)
    if results.present?
      self.state = results.first.state
      self.country = results.first.country
    else
      self.state = 'Unknown'
      self.country = 'Unknown'
    end
  end
end
