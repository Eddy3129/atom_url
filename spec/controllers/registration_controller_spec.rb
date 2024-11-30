# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let!(:user) { User.create!(email: 'user@example.com', password: 'password123', password_confirmation: 'password123') }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user, scope: :user)
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user and redirects to the root path' do
        expect(User.count).to eq(1) # Ensure there's 1 user before creation

        post :create,
             params: { user: { email: 'new_user1@example.com', password: 'password123',
                               password_confirmation: 'password123' } }

        # Verify the user was created
        expect(User.count).to eq(2) # The new user should be created

        # Ensure it redirects correctly
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid password attributes' do
      it 'updates the user password and keeps the email unchanged' do
        old_email = user.email
        old_password_digest = user.encrypted_password

        put :update,
            params: { user: { password: 'newpassword123', password_confirmation: 'newpassword123',
                              current_password: user.password } }

        expect(response).to redirect_to(root_path)
        user.reload
        expect(user.encrypted_password).not_to eq(old_password_digest)
        expect(user.email).to eq(old_email)
      end
    end

    context 'with invalid password confirmation' do
      it 'does not update the password and shows an error message' do
        old_password_digest = user.encrypted_password

        put :update,
            params: { user: { password: 'newpassword123', password_confirmation: 'wrongconfirmation',
                              current_password: user.password } }

        expect(response).to render_template(:edit)

        user.reload
        expect(user.encrypted_password).to eq(old_password_digest)
      end
    end
  end
end
