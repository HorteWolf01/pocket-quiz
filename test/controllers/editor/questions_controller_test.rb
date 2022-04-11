require "test_helper"

class Editor::QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get editor_questions_new_url
    assert_response :success
  end

  test "should get create" do
    get editor_questions_create_url
    assert_response :success
  end

  test "should get edit" do
    get editor_questions_edit_url
    assert_response :success
  end

  test "should get update" do
    get editor_questions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get editor_questions_destroy_url
    assert_response :success
  end
end
