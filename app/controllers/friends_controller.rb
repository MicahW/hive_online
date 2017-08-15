class FriendsController < ApplicationController
  before_action :logged_in_user, only: [:create]
    
  def create
    @user = current_user
    @sender = User.find(params[:user_id])
    add_friendship(@user, @sender)
    @user.friend_request.find_by(user_id: @user.id, from_id: @sender.id).destroy
    send_message(@sender, "#{@user.name} added as friend", "success")
    send_message(@user, "#{@sender.name} added as friend", "success")
    redirect_to @user
  end
  
  def destroy
    @user = current_user
    @friend = User.find(params[:user_id])
    remove_friendship(@user, @friend)
    send_message(@friend, "#{@user.name} removed as friend", "warning")
    send_message(@user, "#{@friend.name} removed as friend", "warning")
    redirect_to @user
  end
end
