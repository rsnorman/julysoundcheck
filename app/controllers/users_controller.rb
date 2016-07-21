class UsersController < ApplicationController
  before_action :set_user

  def update
    @user.update(user_params)
    redirect_to reviewer_path(@user.twitter_screen_name)
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
