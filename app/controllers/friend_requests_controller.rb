class FriendRequestsController < ApplicationController
  
  def create
    @sender = current_user
    @user = User.find(params[:user_id])
    if !@user.friend_request.exists?(from_id: @sender.id) and
       !@sender.friend_request.exists?(from_id: @user.id)
      @user.friend_request.create(from_id: @sender.id)
    end
    redirect_to index_path
  end
  
  def destroy
    @user = current_user
    @request = @user.friend_request.find_by(from_id: params[:user_id])
    @request.destroy
    redirect_to @user
  end
  
end
