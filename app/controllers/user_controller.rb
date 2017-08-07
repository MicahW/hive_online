class UserController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]
  
  layout "application.html.erb"
  def show
    @active = Hash.new("")
    @active[:home] = "active"
    @user = User.find(params[:id])
    @show_edit = logged_in? && @user == current_user
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
  end
  
  def new
    @active = Hash.new("")
    @user = User.new
  end
  
  def create
    @active = Hash.new("")
    @user = User.new(user_params)
    if @user.save
      @user.color = "orange"
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       redirect_to @user
    else
      @active = Hash.new("new")
      @active[:settings] = "active"
      render 'edit'
    end
  end
 
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
