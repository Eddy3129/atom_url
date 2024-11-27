# frozen_string_literal: true

require 'rails_helper'

# spec/services/url_shortener_service_spec.rb
RSpec.describe UrlShortenerService, type: :service do
  let(:valid_url) { 'https://example.com' }
  let(:invalid_url) { 'invalid-url' }

  describe '#shorten' do
    context 'when the URL is valid' do
      it 'creates a URL successfully' do
        service = UrlShortenerService.new(valid_url)
        url = service.shorten
        expect(url).to be_a(Url)
        expect(url.original_url).to eq(valid_url)
        expect(url.errors).to be_empty
      end
    end

    context 'when the URL is invalid' do
      it 'returns an error and does not create a URL' do
        service = UrlShortenerService.new(invalid_url)
        url = service.shorten
        expect(url.errors).not_to be_empty
        expect(url.errors[:base]).to include('Invalid URL format')
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(URI).to receive(:parse).and_raise(StandardError)
      end

      it 'handles the error gracefully' do
        service = UrlShortenerService.new(valid_url)
        url = service.shorten
        expect(url.errors[:base]).to include('An unexpected error occurred while shortening the URL.')
      end
    end
  end
end
