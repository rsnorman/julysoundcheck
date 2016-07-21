class UsersController < ApplicationController
  before_action :set_user

  def update
    @user.update(user_params)
    redirect_to reviewer_path(@user.twitter_screen_name), notice: 'You profile was updated successfully'
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def set_user
    unless current_user
      redirect_to root_path, error: 'Please sign out and sign in again'
      return false
    end
    @user = User.find(current_user.id)
  end
end
