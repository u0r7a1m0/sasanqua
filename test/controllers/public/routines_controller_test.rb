require "test_helper"

class Public::RoutinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_routines_index_url
    assert_response :success
  end

  test "should get new" do
    get public_routines_new_url
    assert_response :success
  end

  test "should get show" do
    get public_routines_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_routines_edit_url
    assert_response :success
  end
end
