class SessionsController < ApplicationController
  def new
    @flash = Hash.new("")
    @flash[:danger] = false
    @active = Hash.new("")
    @active[:login] = "active"
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      cookies.signed[:user_id] = user.id
      redirect_back_or user
    else
      @active = Hash.new("")
      flash[:danger]
      render 'new'
    end
  end

  def destroy
    log_out
    session.delete(:user_id)
    cookies.delete(:remember_token)
    redirect_to root_url
  end
end
