class ReviewerStatsController < ApplicationController
  before_action :set_user, only: :index
  before_action :set_stats, only: :index

  private

  def set_user
    @screen_name = params[:screen_name]
    @user = User.find_by(twitter_screen_name: @screen_name)
    @user ||= User.find_by(slug: @screen_name)
  end

  def set_stats
  end
end
