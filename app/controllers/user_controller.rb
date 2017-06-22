class UserController < ApplicationController
  layout "application.html.erb"
  def show
    @hash = Hash.new("")
    @user = User.find(params[:id])
  end

  def new
    @hash = Hash.new("")
    @user = User.new
  end
  
  def create
    @hash = Hash.new("")
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    color = params[:user][:color]
    @user = user = User.find_by(id: params[:id])
    @user.update_attribute(:color, color)
    @hash = Hash.new("")
    render 'show'
  end
 
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
