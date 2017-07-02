class ApplicationController < ActionController::Base
  force_ssl if: :ssl_configured?
  protect_from_forgery with: :exception
  helper :application

  before_action :authenticate_user!

  private

  def ssl_configured?
    !Rails.env.development?
  end
end
