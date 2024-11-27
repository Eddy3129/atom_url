# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, email: 'user@example.com', password: 'password123') }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    it 'signs the user in and redirects to the root path' do
      post :create, params: { user: { email: user.email, password: 'password123' } }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'DELETE #destroy' do
    it 'signs the user out and redirects to the root path' do
      sign_in user
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
