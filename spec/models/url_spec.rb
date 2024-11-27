# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:user) { create(:user) }
  let(:valid_url) { 'https://example.com' }
  let(:invalid_url) { 'invalid-url' }

  describe 'validations' do
    it 'is valid with a valid URL' do
      url = Url.new(original_url: valid_url, user: user)
      expect(url).to be_valid
    end

    it 'is invalid with an invalid URL' do
      url = Url.new(original_url: invalid_url, user: user)
      expect(url).not_to be_valid
    end

    it 'requires a short_code' do
      url = Url.new(original_url: valid_url, user: user)
      url.short_code = nil
      expect(url).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should have_many(:visits).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'generates a unique short_code' do
      url = Url.create(original_url: valid_url, user: user)
      expect(url.short_code).not_to be_nil
    end
  end
end
