class SessionsController < ApplicationController
  def create
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    session_creator.create
    redirect_to root_path, notice: 'Signed in'
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end

  private

  def session_creator
    SessionCreator.new(twitter_user)
  end
end
