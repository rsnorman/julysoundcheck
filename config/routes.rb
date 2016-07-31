Rails.application.routes.draw do
  resources :tweets, only: nil do
    resources :tweet_reviews, only: :new
  end

  resources :tweet_reviews, only: [:new, :edit, :create, :update]

  get '/reviewers/:screen_name/feed', to: 'reviewer_feed_items#index', as: :reviewer
  get '/reviewers/:screen_name/stats', to: 'reviewer_stats#index', as: :reviewer_stats

  get '/ratings/:rating/reviews', to: 'reviews#index', as: :ratings

  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  delete '/signout', to: 'sessions#destroy', as: 'signout'
  get '/profile', to: 'users#edit'

  resources :users, only: :update

  resources :albums, only: :index

  root 'feed_items#index'
end
