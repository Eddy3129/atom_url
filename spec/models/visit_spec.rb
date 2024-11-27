# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Visit, type: :model do
  let(:url) { create(:url) }
  let(:visit) { Visit.new(url: url, ip_address: '192.168.1.1') }

  it 'is valid with valid attributes' do
    expect(visit).to be_valid
  end

  it 'is invalid without an IP address' do
    visit.ip_address = nil
    expect(visit).not_to be_valid
  end

  describe 'geocoding' do
    it 'should geocode the IP address' do
      expect(visit).to receive(:geocode)
      visit.valid?
    end
  end
end
