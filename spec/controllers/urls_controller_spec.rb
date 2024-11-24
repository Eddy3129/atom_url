# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Url' do
        expect do
          post :create, params: { url: { original_url: 'https://example.com' } }
        end.to change(Url, :count).by(1)
      end

      it 'redirects to the created url' do
        post :create, params: { url: { original_url: 'https://example.com' } }
        expect(response).to redirect_to(Url.last)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Url' do
        expect do
          post :create, params: { url: { original_url: 'invalid_url' } }
        end.to change(Url, :count).by(0)
      end

      it 'renders the index template' do
        post :create, params: { url: { original_url: 'invalid_url' } }
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #show' do
    let(:url) { Url.create!(original_url: 'https://example.com') }

    it 'returns a success response' do
      get :show, params: { id: url.to_param }
      expect(response).to be_successful
    end

    it 'assigns the requested url to @url' do
      get :show, params: { id: url.to_param }
      expect(assigns(:url)).to eq(url)
    end
  end
end
