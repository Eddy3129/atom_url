# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User Registration', type: :feature do
  scenario 'user registers successfully' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'password123'
    click_button 'Sign Up / Log In'
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'user fails to register with invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'password223'
    click_button 'Sign up'
    expect(page).to have_content('Password confirmation doesn’t match Password')
  end

  scenario 'user fails to register with invalid email format' do
    visit new_user_registration_path
    fill_in 'Email', with: 'invalid_email'
    fill_in 'user[password]', with: 'password123'
    fill_in 'user[password_confirmation]', with: 'password123'
    click_button 'Sign up'
    expect(page).to have_content('Email is invalid')
  end

  scenario 'user fails to register with missing password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'user[password_confirmation]', with: 'password123'
    click_button 'Sign up'
    expect(page).to have_content("Password can't be blank")
  end
end
