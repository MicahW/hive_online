#require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  
  test "colors" do
    get root_path
    assert_select "ul", {:class => "orange"}
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    follow_redirect!
    assert_select "ul", {:class => "purple"}
  end

    
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
  end
  
  test "friednly fowarding" do
    get index_path
    assert_redirected_to login_path
    follow_redirect!
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' }}
    assert_redirected_to index_path
    follow_redirect!
    assert_select "ul.users"
    assert_response :success
  end


end