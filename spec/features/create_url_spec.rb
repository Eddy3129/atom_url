# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Url Shortening', type: :feature do

  scenario 'user creates a short URL' do
    visit root_path
    fill_in 'Original URL', with: 'https://example.com'
    click_button 'Shorten'
    expect(page).to have_content('URL shortened successfully')
    expect(Url.last.original_url).to eq('https://example.com')
  end
end
