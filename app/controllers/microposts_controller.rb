class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    if create_micropost?
      flash[:success] = t ".success"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed,
                                items: Settings.digits.size_of_page
      flash.now[:danger] = t ".failed"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def create_micropost?
    @micropost = current_user.feed.build micropost_params
    @micropost.image.attach micropost_params[:image]
    @micropost.save
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.feed.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "users.unauthorized"
    redirect_to request.referer || root_url
  end
end
