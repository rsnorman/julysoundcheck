class UsersController < ApplicationController
  before_action :set_user

  def update
    @user.update(user_params)
    redirect_to user_path(@user),
                notice: 'You profile was updated successfully'
  end

  private

  def user_path(user)
    user.twitter_screen_name ?
      reviewer_path(user.twitter_screen_name) :
      reviewer_path(user.id)
  end

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
