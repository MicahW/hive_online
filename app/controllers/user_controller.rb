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
      # Handle a successful save.
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
