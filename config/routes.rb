Rails.application.routes.draw do
  resources :tweets, only: :index

  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  delete '/signout', to: 'sessions#destroy', as: 'signout'

  root 'tweets#index'
end
