# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User Account Update', type: :feature do
  let(:user) { create(:user, email: 'user@example.com', password: 'password123') }

  before do
    sign_in user
  end

  scenario 'user updates their email successfully' do
    visit edit_user_registration_path
    fill_in 'Email', with: 'new_email@example.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'password123'
    click_button 'Update'
    expect(page).to have_content('Your account has been updated successfully.')
    user.reload
    expect(user.email).to eq('new_email@example.com')
  end

  scenario 'user fails to update with invalid data' do
    visit edit_user_registration_path
    fill_in 'Email', with: 'new_email@example.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'wrongpassword'
    click_button 'Update'
    expect(page).to have_content('Password confirmation doesn’t match Password')
  end
end
