# frozen_string_literal: true

source 'https://rubygems.org'

# Rails: Web framework for developing full-stack applications
gem 'rails', '~> 8.0.0'

# Propshaft: Modern asset pipeline for Rails (replaces Sprockets)
gem 'propshaft'

# PostgreSQL: Use PostgreSQL as the database for Active Record
gem 'pg', '~> 1.1'

# Puma: Web server for serving Rails apps, supports concurrent connections
gem 'puma', '>= 5.0'

# Importmap for Rails: JavaScript with ESM import maps (no bundler required)
gem 'importmap-rails'

# Turbo-Rails: Hotwire library for enabling SPA-like features without full JavaScript
gem 'turbo-rails'

# Stimulus-Rails: JavaScript framework for modest interactions (part of Hotwire)
gem 'stimulus-rails'

# TailwindCSS: Utility-first CSS framework for rapid UI development
gem 'tailwindcss-rails'

# Jbuilder: Build JSON APIs for your Rails application
gem 'jbuilder'

# Uncomment this line to use bcrypt for secure password storage (optional)
# gem "bcrypt", "~> 3.1.7"

# TZInfo Data: Ensures proper timezone data on Windows and JRuby platforms
gem 'tzinfo-data', platforms: %i[windows jruby]

# Solid Cache, Solid Queue, Solid Cable: Rails database-backed adapters for cache, background jobs, and real-time features
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

# Bootsnap: Speeds up Rails boot time by caching expensive operations
gem 'bootsnap', require: false

# Kamal: Deploy Rails apps to Docker environments
gem 'kamal', require: false

# Thruster: HTTP asset caching and compression for Puma
gem 'thruster', require: false

# Uncomment this line to use image processing for Active Storage variants (optional)
# gem "image_processing", "~> 1.2"

# Development and Test specific gems

group :development, :test do
  # Debugging tool for inspecting Rails apps in development
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Brakeman: Static analysis for security vulnerabilities in Rails apps
  gem 'brakeman', require: false

  # RuboCop: Linting tool for Ruby code style enforcement
  gem 'rubocop', require: false

  # RuboCop Rails: Additional RuboCop rules for Rails applications
  gem 'rubocop-rails', require: false

  # dotenv-rails: Loads environment variables from a .env file
  gem 'dotenv-rails'
end

# Development-only gems

group :development do
  # Web-console: Provides an interactive console on error pages in development
  gem 'web-console'
end

# Test-specific gems

group :test do
  # Capybara: Integration testing tool for simulating user interaction in the browser
  gem 'capybara'

  # FactoryBot: Easy factory-based object creation for tests
  gem 'factory_bot_rails'

  # Faker: Generate fake data for testing
  gem 'faker'

  # Rails Controller Testing: Additional testing helpers for controllers
  gem 'rails-controller-testing'

  # RSpec: BDD testing framework for Ruby
  gem 'rspec-rails'

  # Selenium WebDriver: WebDriver for browser-based system testing
  gem 'selenium-webdriver'

  # Shoulda Matchers: Provides RSpec-compatible matchers for Rails tests
  gem 'shoulda-matchers'
end

# Geocoder: Provides geocoding and reverse geocoding functionality
gem 'geocoder'

# Nokogiri: HTML, XML parsing library (useful for scraping or XML-based APIs)
gem 'nokogiri'

# Chartkick: Easy chart creation for Rails apps
gem 'chartkick'

# Groupdate: Adds time-based grouping methods for ActiveRecord queries (e.g., by week, month, etc.)
gem 'groupdate'

# Kaminari: Pagination library for ActiveRecord collections
gem 'kaminari'

# Devise: Authentication solution for Rails apps
gem 'devise'

# Sidekiq: Background job processing for Rails apps
gem 'sidekiq'

# Redis: In-memory data structure store, required by Sidekiq
gem 'redis'

# Hiredis: Fast Redis client for Ruby
gem 'hiredis'

# HTTParty: Simplifies making HTTP requests and working with APIs
gem 'httparty'
