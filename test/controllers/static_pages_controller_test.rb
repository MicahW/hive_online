require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_select "a#active", "Home"
    assert_select "a#active[href=?]", root_path
    assert_response :success
  end

  test "should get contact" do
    get contact_path
    assert_select "a#active", "Contact"
    assert_select "a#active[href=?]", contact_path
    assert_response :success
  end

end
