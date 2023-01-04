require "test_helper"

class RoutinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get routines_index_url
    assert_response :success
  end

  test "should get new" do
    get routines_new_url
    assert_response :success
  end

  test "should get show" do
    get routines_show_url
    assert_response :success
  end

  test "should get edit" do
    get routines_edit_url
    assert_response :success
  end
end
