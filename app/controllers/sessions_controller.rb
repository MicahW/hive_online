class SessionsController < ApplicationController
  def new
    @flash = Hash.new("")
    @flash[:danger] = false
    @hash = Hash.new("")
    @hash[:login] = "active"
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      @hash = Hash.new("")
      @flash = Hash.new("")
      @flash[:danger] = true
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
