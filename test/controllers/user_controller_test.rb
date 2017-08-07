require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @cracker = users(:cracker)
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post '/signup', params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
  end
  
  test "succsessfull update" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get edit_user_path(@user)
    assert_select "h1", "Update your profile"
    patch user_path(@user), params: { user: { name:  "mike",
                                         email: "mike@example.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar" } }
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    @user.reload
    assert_equal "mike", @user.name
    assert_equal "mike@example.com", @user.email
  end
  
  test "unsuccsessfull update" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get edit_user_path(@user)
    assert_select "h1", "Update your profile"
    patch user_path(@user), params: { user: { name:  "mike",
                                         email: "mike@example.com",
                                         password:              "foobar",
                                         password_confirmation: "foo" } }
    @user.reload
    assert_equal "michael@example.com", @user.email
  end
  
  test "only user can update themselves" do
    get login_path
    post login_path, params: { session: { email:    @cracker.email,
                                         password: 'password' } }
    get edit_user_path(@user)
    assert_select "h1", "Update your profile"
    patch user_path(@user), params: { user: { name:  "mike",
                                         email: "mike@example.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar" } }
    @user.reload
    assert_equal "michael@example.com", @user.email    
  end
    
  
  
  
end
