require 'test_helper'

class AdminDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @admin = users(:admin)
    @cracker = users(:cracker)
  end
  
  test "admin succsesfully deletes" do
    get login_path
    post login_path, params: { session: { email:    @admin.email,
                                          password: 'password' } }
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end
  
  test "ony admin can delete" do
    post login_path, params: { session: { email:    @cracker.email,
                                          password: 'password' } }
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
  end
end
