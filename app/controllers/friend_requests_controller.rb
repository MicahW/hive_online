class FriendRequestsController < ApplicationController
  
  def create
    @sender = current_user
    @user = User.find(params[:user_id])
    puts @sender.id.class
    @user.friend_request.create(from_id: @sender.id)
    redirect_to index_path
  end
  
end
