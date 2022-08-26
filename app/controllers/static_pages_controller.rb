class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.feed.build
    @pagy, @feed_items = pagy(current_user.feed.newest)
  end

  def help; end
end
