class FriendRequestsController < ApplicationController
  
  def create
    @sender = current_user
    @user = User.find(params[:user_id])
    if !@user.friend_request.exists?(from_id: @sender.id)
      @user.friend_request.create(from_id: @sender.id)
    end
    redirect_to index_path
  end
  
end
