require 'test_helper'

class SendingFriendRequestsTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @user = users(:michael)
    @admin = users(:admin)
    @cracker = users(:cracker)
  end
  
 test "send friend request adds to db, but second dose not" do
   post login_path, params: { session: { email:    @user.email,
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
 end
end
