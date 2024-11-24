# frozen_string_literal: true

# config/routes.rb

Rails.application.routes.draw do
  get 'analytics/show'
  resources :urls, only: %i[index create destroy]

  get '/:short_code', to: 'redirects#show', as: 'short'
  # Add root route if not already present
  root 'urls#index'
  # Route for analytics
  get 'analytics/:id', to: 'analytics#show', as: 'analytics'
end
