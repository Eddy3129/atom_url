# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeolocationService, type: :service do
  let(:ip_address) { '192.168.1.1' }
  let(:valid_geolocation) do
    {
      latitude: 37.7749,
      longitude: -122.4194,
      city: 'San Francisco',
      state: 'CA',
      country: 'United States',
      country_code: 'US',
      postal_code: '94103',
      timezone: 'America/Los_Angeles',
      coordinates: [37.7749, -122.4194]
    }
  end

  let(:invalid_ip) { '999.999.999.999' }

  describe '#fetch_geolocation' do
    context 'when geolocation is found' do
      before do
        allow_any_instance_of(GeolocationService).to receive(:geocode_ip).and_return(double(latitude: 37.7749,
                                                                                            longitude: -122.4194, city: 'San Francisco', state: 'CA', country: 'United States', country_code: 'US', postal_code: '94103', timezone: 'America/Los_Angeles', coordinates: [37.7749, -122.4194], time_zone: 'America/Los_Angeles'))
      end

      it 'returns the correct geolocation data' do
        service = GeolocationService.new(ip_address)
        expect(service.fetch_geolocation).to eq(valid_geolocation)
      end
    end

    context 'when geolocation is not found' do
      before do
        allow_any_instance_of(GeolocationService).to receive(:geocode_ip).and_return(nil)
      end

      it 'returns an error message' do
        service = GeolocationService.new(invalid_ip)
        expect(service.fetch_geolocation[:error]).to eq('No geolocation data found for IP: 999.999.999.999')
      end
    end
  end
end
