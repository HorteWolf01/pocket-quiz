require "test_helper"

class Api::QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_questions_show_url
    assert_response :success
  end

  test "should get delete" do
    get api_questions_delete_url
    assert_response :success
  end

  test "should get add" do
    get api_questions_add_url
    assert_response :success
  end

  test "should get add_answer" do
    get api_questions_add_answer_url
    assert_response :success
  end

  test "should get update_answer" do
    get api_questions_update_answer_url
    assert_response :success
  end

  test "should get delete_answer" do
    get api_questions_delete_answer_url
    assert_response :success
  end
end
