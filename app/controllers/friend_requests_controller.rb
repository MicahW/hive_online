class FriendRequestsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit]
  
  def create
    #only process this if the user has not already sent a request, 
    #and there dose not exists a friendship already
    @sender = current_user
    @user = User.find(params[:user_id])
    
    if !@user.friend_request.exists?(from_id: @sender.id) and
       !exists_friendship?(@user, @sender)
    
    #if this is the first friend request
    if !@sender.friend_request.exists?(from_id: @user.id) and
      @user.friend_request.create(from_id: @sender.id)
      send_message(@sender, "friend request sent to #{@user.name}", "success")
      send_message(@user, "you got a friend request form #{@sender.name}", "success")
    #both users have sent friend requests to eachother, make friendship
    else
      send_message(@sender, "#{@user.name} added as friend", "success")
      send_message(@user, "#{@sender.name} added as friend", "success")
      add_friendship(@user, @sender)
      @sender.friend_request.find_by(from_id: @user.id).destroy
    end
    end
    redirect_to index_path
  end
  
  def destroy
    @user = current_user
    @sender = User.find(params[:user_id])
    
    request = @user.friend_request.find_by(from_id: @sender.id)
    request.destroy if (request)
      
    request = @sender.friend_request.find_by(from_id: @user.id)
    request.destroy if (request) 
    
    send_message(@user, "friend request with #{@sender.name} declined", "warning")
    send_message(@sender, "friend request with #{@user.name} declined", "warning")
      
    redirect_to @user
  end
  
end
