Rails.application.routes.draw do
  root "urls#index"
  resources :urls, only: [:index, :create, :show]

  # Route for short URLs
  get "/:short_code", to: "redirects#show", as: :short
end
