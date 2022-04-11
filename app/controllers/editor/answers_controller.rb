class Editor::AnswersController < ApplicationController
  def create
    question = Question.find_by(:id => params[:id])
    question.answers.create!(
      params[:new].permit(
        :right,
        :text
      )
    )
    uuid = question.quiz.uuid
    q = question.quiz.questions.index{|i| i.id == question.id }
    redirect_to "/editor/quizzes/#{uuid}/q/#{q}"
  rescue => e
    flash[:notice] = e.message
  end

  def update
    return destroy if params[:commit] == 'Del'
    answer = Answer.find_by(:id => params[:id])
    answer.update!(
      params[:answer].permit(
        :right,
        :text
      )
    )
    question = answer.question
    uuid = question.quiz.uuid
    q = question.quiz.questions.index{|i| i.id == question.id }
    redirect_to "/editor/quizzes/#{uuid}/q/#{q}"
  rescue => e
    flash[:notice] = e.message
  end

  def destroy
    answer = Answer.find_by(:id => params[:id])
    question = answer.question
    uuid = question.quiz.uuid
    q = question.quiz.questions.index{|i| i.id == question.id }
    answer.destroy!
    redirect_to "/editor/quizzes/#{uuid}/q/#{q}"
  rescue => e
    flash[:notice] = e.message
  end
end
