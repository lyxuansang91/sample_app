class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
    @users = User.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @user = User.new
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "user deleted!"
      redirect_to users_path
    end
  end

  def create
    # byebug
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_back_or user
    else
      flash[:danger] = "Sign up error!"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes user_params
      # Handle a successful update
      flash[:success] = "Update successfully!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.required(:user).permit(:name,
      :email,
      :password,
      :password_confirmation)
  end

  def signed_in_user
    unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
