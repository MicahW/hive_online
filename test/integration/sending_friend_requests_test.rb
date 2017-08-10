require 'test_helper'

class SendingFriendRequestsTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @michael = users(:michael)
    @admin = users(:admin)
    @cracker = users(:cracker)
  end
  
 test "friend requests" do
   post login_path, params: { session: { email:    @michael.email,
                                          password: 'password' } }
   get index_path
   assert_difference '@bob.friend_request.count', 1 do
    post user_friend_requests_path(@bob)
    assert_redirected_to index_path
    follow_redirect!
   end
   
   #second request should not add another one
   assert_no_difference '@bob.friend_request.count' do
    post user_friend_requests_path(@bob)
    assert_redirected_to index_path
   end
   delete logout_path
   
   #now bob should not be able to send friend request to michael
   post login_path, params: { session: { email:    @bob.email,
                                          password: 'password' } }
   get user_path(@bob)
   #testing delting a friend request
   assert_difference '@bob.friend_request.count', -1 do
    delete user_friend_request_path(user_id: @michael.id)
    assert_redirected_to @bob
   end
   
 end
  
  
 test "acepting a friend request" do
   post login_path, params: { session: { email:    @michael.email,
                                          password: 'password' } }
   post user_friend_requests_path(@bob)
   delete logout_path
   
   post login_path, params: { session: { email:    @bob.email,
                                          password: 'password' } }
   
   assert_difference "@bob.friend_request.count", -1 do
     post user_friends_path(user_id: @michael.id)
   end
   assert_equal @michael.friend.count, 1
   assert_equal @bob.friend.count, 1
   assert_equal @michael.friend.first.friend_id, @bob.id
 end 
  
 test "mutail friends request creats friendship" do
   post login_path, params: { session: { email:    @michael.email,
                                          password: 'password' } }
   post user_friend_requests_path(@bob)
   delete logout_path
   
   post login_path, params: { session: { email:    @bob.email,
                                          password: 'password' } }
   
   assert_difference "@bob.friend_request.count", -1 do
     post user_friend_requests_path(user_id: @michael.id)
   end
   assert_equal @michael.friend.count, 1
   assert_equal @bob.friend.count, 1
   assert_equal @michael.friend.first.friend_id, @bob.id
 end
  
end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   
