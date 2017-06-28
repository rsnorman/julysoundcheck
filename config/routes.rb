Rails.application.routes.draw do
  devise_for :users
  resources :tweets, only: nil do
    resources :tweet_reviews, only: :new
  end

  resources :tweet_reviews, only: [:new, :edit, :create, :update]

  get '/aotm', to: 'aotm#index', as: :aotm

  get '/reviewers/:screen_name/feed', to: 'reviewer_feed_items#index', as: :reviewer

  get '/ratings/:rating/reviews', to: 'reviews#index', as: :ratings

  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  delete '/signout', to: 'sessions#destroy', as: 'signout'

  get '/profile', to: 'reviewer_feed_items#index'
  get '/settings', to: 'users#edit'

  resources :users, only: :update

  resources :albums, only: :index

  root 'feed_items#index'
end
