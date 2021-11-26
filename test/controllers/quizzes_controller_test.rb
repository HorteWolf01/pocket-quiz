require "test_helper"

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  test "should get question" do
    get quizzes_question_url
    assert_response :success
  end
end
