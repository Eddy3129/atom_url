Rails.application.routes.draw do
  resources :urls, only: [:index, :create, :show]
  get '/:short_code', to: 'urls#redirect', as: :short
  # Add root route if not already present
  root 'urls#index'
end
