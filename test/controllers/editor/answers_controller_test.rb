require "test_helper"

class Editor::AnswersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get editor_answers_create_url
    assert_response :success
  end

  test "should get update" do
    get editor_answers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get editor_answers_destroy_url
    assert_response :success
  end
end
