class UserController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]
  
  layout "application.html.erb"
  def show
    @hash = Hash.new("")
    @hash[:user] = "active"
    @user = User.find(params[:id])
    @show_edit = logged_in? && @user == current_user
  end
  
  def index
    @hash = Hash.new("")
    @hash[:index] = "active"
    @user = User.paginate(page: params[:page])
  end
  
  def new
    @hash = Hash.new("")
    @user = User.new
  end
  
  def create
    @hash = Hash.new("")
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
    color = params[:user][:color]
    @user = user = User.find_by(id: params[:id])
    puts @user.name
    puts current_user.name
    if logged_in? && current_user == @user
      puts "-------------------------updateing" 
      @user.update_attribute(:color, color)
      @hash = Hash.new("")
    end
    redirect_to @user
  end
 
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
