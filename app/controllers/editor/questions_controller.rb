class Editor::QuestionsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    @quiz = Quiz.find_by(:uuid => params[:uuid])
  rescue => e
    flash[:notice] = e.message
  end

  def create
    quiz = Quiz.find_by(:uuid => params[:uuid])
    quiz.questions.create!(
      params[:question].permit(
        :text,
        :points,
        :question_type
      )
    )
    redirect_to "/editor/quizzes/#{quiz.uuid}"
  rescue => e
    flash[:notice] = e.message
  end

  def edit
    @quiz = Quiz.find_by(:uuid => params[:uuid])
    @question = @quiz.questions[params[:q].to_i]
    @answers = @question.answers
  rescue => e
    flash[:notice] = e.message
  end

  def update

  end

  def destroy
    quiz = Quiz.find_by(:uuid => params[:uuid])
    quiz.questions[params[:q].to_i].destroy!
    redirect_to "/editor/quizzes/#{quiz.uuid}"
  rescue => e
    flash[:notice] = e.message
  end
end
