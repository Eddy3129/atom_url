require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe 'GET #show' do
    let(:url) { Url.create!(original_url: 'https://example.com', short_code: 'abc123') }

    context 'when the short_code exists' do
      it 'redirects to the original URL and creates a Visit with state and country' do
        expect {
          get :show, params: { short_code: url.short_code }
        }.to change(Visit, :count).by(1)

        visit = Visit.last
        expect(response).to redirect_to(url.original_url)
        expect(visit.state).to be_present
        expect(visit.country).to be_present
      end
    end

    context 'when the short_code does not exist' do
      it 'renders a 404 page' do
        get :show, params: { short_code: 'nonexistent' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
