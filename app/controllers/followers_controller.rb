class FollowersController < ApplicationController
  before_action :find_user
  def index
    if @user&.activated
      @title = t ".title"
      @pagy, @users = pagy @user.followers
      render "users/show_follow"
    else
      user_not_activated
    end
  end
end
