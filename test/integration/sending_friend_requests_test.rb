require 'test_helper'

class SendingFriendRequestsTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @michael = users(:michael)
    @admin = users(:admin)
    @cracker = users(:cracker)
  end
  
 test "send friend request adds to db, but second dose not" do
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
   
   #second request should not add another one
   assert_no_difference '@michael.friend_request.count' do
    post user_friend_requests_path(@michael)
   end  
 end
end
