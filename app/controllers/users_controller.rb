class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]

    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t ".success_message"
      redirect_to @user
    else
      flash[:danger] = t ".failure_message"
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end
end