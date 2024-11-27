# frozen_string_literal: true

# spec/controllers/urls_controller_spec.rb
require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:url) { create(:url, user: user) }  # Create the URL before running the test

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns @urls for logged-in users' do
      get :index
      expect(assigns(:urls)).to include(url)  # Ensure the URL is assigned
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'DELETE #destroy' do
  it 'deletes the URL when the user owns it' do
    expect do
      delete :destroy, params: { id: url_to_delete.id }, format: :turbo_stream
    end.to change(Url, :count).by(-1)

    # Ensure Turbo Stream response removes the URL from the page
    expect(response.body).to include("<turbo-stream action=\"remove\" target=\"url_#{url_to_delete.id}\">")
  end

  it 'does not delete the URL if the user does not own it' do
    another_user = create(:user)
    url_to_delete = create(:url, user: another_user)

    expect do
      delete :destroy, params: { id: url_to_delete.id }, format: :turbo_stream
    end.not_to change(Url, :count)

    # Ensure response contains an error message
    expect(response.body).to include('Unauthorized')
  end
  end
end
