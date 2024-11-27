# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    original_url { 'https://www.example.com' }
    short_code { SecureRandom.hex(4) }
    title { 'Example' }
    user
  end
end
