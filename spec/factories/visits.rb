# frozen_string_literal: true

# spec/factories/visits.rb
FactoryBot.define do
  factory :visit do
    association :url
    ip_address { Faker::Internet.ip_v4_address }
    created_at { Time.zone.now }
  end
end
