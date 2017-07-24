require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_select "li.active"
    assert_select "[href=?]", root_path
    assert_response :success
  end
end
