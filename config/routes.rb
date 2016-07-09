Rails.application.routes.draw do
  resources :tweets, only: :index
  resources :tweet_reviews, only: [:new, :edit, :create, :update]

  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  delete '/signout', to: 'sessions#destroy', as: 'signout'

  resources :albums, only: :index

  root 'tweets#index'
end
