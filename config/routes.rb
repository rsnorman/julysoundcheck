Rails.application.routes.draw do
  resources :tweets, only: :index do
    resources :tweet_reviews, only: :new
  end
  resources :tweet_reviews, only: [:new, :edit, :create, :update]

  get '/reviewers/:screen_name/tweets', to: 'reviewer_tweets#index', as: :reviewer

  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  delete '/signout', to: 'sessions#destroy', as: 'signout'

  resources :albums, only: :index

  root 'tweets#index'
end
