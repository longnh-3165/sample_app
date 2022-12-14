class UsersController < ApplicationController
  before_action :correct_user, only: %i(edit update)
  before_action :find_by_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(create new)
  before_action :can_is_admin?, only: :destroy

  def show
    @pagy, @microposts = pagy @user.microposts.newest,
                              items: Settings.digits.size_of_page
  end

  def index
    @pagy, @users = pagy User.activated.sort_name,
                         items: Settings.digits.size_of_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".mail_activation_message"
      redirect_to login_url
    else
      flash[:danger] = t ".failure_message"
      render :new
    end
  end

  def edit; end

  def destroy
    if @user.destroy
      flash[:success] = t ".deleted_message"
    else
      flash[:danger] = t ".delete_failed_message"
    end
    redirect_to users_url
  end

  def update
    if @user.update(user_params)
      flash[:success] = t ".success_message"
      redirect_to @user
    else
      flash[:danger] = t ".failure_message"
      render "edit"
    end
  end

  private

  def find_by_user
    find_user
    return if @user&.activated

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def can_is_admin?
    return if current_user.admin?

    flash[:danger] = t ".unauthorization"
    redirect_to root_url
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end
end
