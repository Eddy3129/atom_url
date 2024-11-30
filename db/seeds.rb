# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Define countries and time zones
countries = [
  'United States', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France',
  'India', 'China', 'Japan', 'South Korea', 'Brazil', 'Mexico', 'Italy', 'Spain',
  'Russia', 'South Africa', 'Argentina', 'Saudi Arabia', 'Nigeria', 'Egypt'
]

timezones = [
  'UTC-12', 'UTC-11', 'UTC-10', 'UTC-09', 'UTC-08', 'UTC-07', 'UTC-06', 'UTC-05',
  'UTC-04', 'UTC-03', 'UTC-02', 'UTC-01', 'UTC+00', 'UTC+01', 'UTC+02', 'UTC+03',
  'UTC+04', 'UTC+05', 'UTC+06', 'UTC+07', 'UTC+08', 'UTC+09', 'UTC+10', 'UTC+11',
  'UTC+12'
]

# Find user and create URL
user = User.find_by(email: 'a@gmail.com') # Replace with your actual email
url = user.urls.create(original_url: 'http://example.com', title: 'Example URL')

# Generate random visits for past week, past month, and past year
# You can adjust the range and time periods to match your use case

# Generate 30 visits (to cover a spread over the last week, month, and year)
30.times do
  # Random visit creation for different countries and dates
  Visit.create(
    url: url,
    ip_address: "192.168.1.#{rand(1..255)}",
    latitude: rand(-90.0..90.0),
    longitude: rand(-180.0..180.0),
    city: "City#{rand(1..100)}",
    state: "State#{rand(1..50)}",
    country: countries.sample, # Randomly select a country from the list
    country_code: "C#{rand(1..10)}",
    postal_code: "100#{rand(1..999)}",
    timezone: timezones.sample, # Randomly select a timezone
    created_at: rand(1..7).days.ago, # Random date within the past week
    updated_at: Time.zone.now
  )
end

# Generate visits for the past month
30.times do
  Visit.create(
    url: url,
    ip_address: "192.168.1.#{rand(1..255)}",
    latitude: rand(-90.0..90.0),
    longitude: rand(-180.0..180.0),
    city: "City#{rand(1..100)}",
    state: "State#{rand(1..50)}",
    country: countries.sample, # Randomly select a country from the list
    country_code: "C#{rand(1..10)}",
    postal_code: "100#{rand(1..999)}",
    timezone: timezones.sample, # Randomly select a timezone
    created_at: rand(8..30).days.ago, # Random date within the past month
    updated_at: Time.zone.now
  )
end

# Generate visits for the past year
30.times do
  Visit.create(
    url: url,
    ip_address: "192.168.1.#{rand(1..255)}",
    latitude: rand(-90.0..90.0),
    longitude: rand(-180.0..180.0),
    city: "City#{rand(1..100)}",
    state: "State#{rand(1..50)}",
    country: countries.sample, # Randomly select a country from the list
    country_code: "C#{rand(1..10)}",
    postal_code: "100#{rand(1..999)}",
    timezone: timezones.sample, # Randomly select a timezone
    created_at: rand(31..365).days.ago, # Random date within the past year
    updated_at: Time.zone.now
  )
end
