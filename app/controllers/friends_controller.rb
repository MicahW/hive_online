class FriendsController < ApplicationController
  
  def create
    @user = current_user
    @sender = User.find(params[:user_id])
    add_friendship(@user, @sender)
    @user.friend_request.find_by(user_id: @user.id, from_id: @sender.id).destroy
    redirect_to @user
  end
  
end
