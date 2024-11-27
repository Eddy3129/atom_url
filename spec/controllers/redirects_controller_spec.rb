# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  let(:url) { create(:url) }

  describe 'GET #show' do
    context 'when the short code exists' do
      it 'redirects to the original URL' do
        get :show, params: { short_code: url.short_code }
        expect(response).to redirect_to(url.original_url)
      end
    end

    context 'when the short code does not exist' do
      it 'renders 404' do
        get :show, params: { short_code: 'nonexistent' }
        expect(response.status).to eq(404)
      end
    end
  end
end
