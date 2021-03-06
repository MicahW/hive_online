class UserController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :update, :edit]
  before_action :correct_user, only: [:update, :edit]
  
  layout "application.html.erb"
  def show
    @active = Hash.new("")
    @active[:profile] = "active"
    @user = User.find(params[:id])
  end
  
  def index
    @active = Hash.new("")
    @active[:players] = "active"
    @user = User.paginate(page: params[:page])
  end
  
  def edit
    @user = User.find(params[:id])
    @active = Hash.new("new")
    @active[:settings] = "active"
    unless current_user?(@user)
      redirect_to edit_user_path(current_user)
    end   
  end
  
  def new
    @active = Hash.new("")
    @user = User.new
  end
  
  def create
    @active = Hash.new("")
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if current_user?(@user) and @user.update(user_params)
       redirect_to @user
    else
      @active = Hash.new("new")
      @active[:settings] = "active"
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy if admin_user?(@user)
    redirect_to index_path 
      
  end
 
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
