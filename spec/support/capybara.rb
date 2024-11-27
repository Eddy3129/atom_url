# spec/support/capybara.rb
require 'capybara/rails'
require 'capybara/rspec'

Capybara.server = :puma # Optional: Use Puma server for faster tests

# Choose the driver (e.g., Chrome, Firefox, etc.)
Capybara.default_driver = :selenium_chrome # or :selenium_chrome_headless for headless
Capybara.javascript_driver = :selenium_chrome # Set the JS driver (can be the same or different)

# Optionally, configure headless mode (for CI or when running in the background)
Capybara.register_driver :selenium_chrome_headless do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: selenium_chrome_headless_options)
end

def selenium_chrome_headless_options
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--window-size=1280x1024') # Optional: for consistent test dimensions
  options
end
