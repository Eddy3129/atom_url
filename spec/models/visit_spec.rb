require 'rails_helper'

RSpec.describe Visit, type: :model do
  let(:url) { Url.create!(original_url: 'https://example.com') }

  describe 'validations' do
    it 'is valid with a url and ip_address' do
      visit = Visit.new(url: url, ip_address: '8.8.8.8')
      expect(visit).to be_valid
    end

    it 'is not valid without an ip_address' do
      visit = Visit.new(url: url, ip_address: nil)
      expect(visit).to_not be_valid
    end
  end

  describe 'geocoding' do
    it 'assigns state and country based on ip_address' do
      visit = Visit.create(url: url, ip_address: '8.8.8.8')
      expect(visit.state).to be_present
      expect(visit.country).to be_present
    end

    it 'handles invalid IP addresses gracefully' do
      visit = Visit.create(url: url, ip_address: '999.999.999.999')
      expect(visit.state).to eq('Unknown')
      expect(visit.country).to eq('Unknown')
    end
  end
end
