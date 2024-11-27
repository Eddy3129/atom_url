# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnalyticsController, type: :controller do
  let(:user) { create(:user) }
  let(:url) { create(:url, user: user) }

  # Bypass the authentication callback
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true) # Skip authentication
    sign_in user # Manually sign in the user
    create_list(:visit, 3, url: url) # Create visits for the URL
  end

  describe 'GET #show' do
    context 'when the user has valid permissions' do
      it 'assigns @visit_counts and @geo_distribution' do
        get :show, params: { id: url.id, period: 'day' }
        expect(assigns(:visit_counts)).to be_present
        expect(assigns(:geo_distribution)).to be_present
        expect(response).to be_successful
      end
    end

    context 'when the URL is not found' do
      it 'redirects to root with an alert' do
        get :show, params: { id: 'invalid_id', period: 'day' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('URL not found.')
      end
    end
  end
end
