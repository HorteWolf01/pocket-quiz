require "test_helper"

class Editor::QuizzesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get editor_quizzes_index_url
    assert_response :success
  end

  test "should get new" do
    get editor_quizzes_new_url
    assert_response :success
  end

  test "should get create" do
    get editor_quizzes_create_url
    assert_response :success
  end

  test "should get show" do
    get editor_quizzes_show_url
    assert_response :success
  end

  test "should get edit" do
    get editor_quizzes_edit_url
    assert_response :success
  end

  test "should get update" do
    get editor_quizzes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get editor_quizzes_destroy_url
    assert_response :success
  end
end
