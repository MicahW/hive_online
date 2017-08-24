class GameController < ApplicationController
  before_action :logged_in_user, only: [:new]
  
  def new
    @active = Hash.new("")
    @user = current_user
    @friend = User.find(params[:user_id])  
    send_invite(@friend, @user.name + " has invited you to a game ", "success", @user) 
  end
  
  def create
     @active = Hash.new("")
     @friend = User.find(params[:user_id])
     GameValidator.start(current_user.id, @friend.id);
  end
end
