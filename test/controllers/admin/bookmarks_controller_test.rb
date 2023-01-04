require "test_helper"

class Admin::BookmarksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_bookmarks_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_bookmarks_show_url
    assert_response :success
  end
end
