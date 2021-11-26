class Api::QuizzesController < ApplicationController
  def index
    render :json => Quiz.all
  end

  def new
    user = User.find_by(:id => params[:id])
    quiz = user.authored_quizzes.create!(:title => params[:title], :description => params[:description])
    render :json => quiz
  end

  def show
    quiz = Quiz.find_by(:uuid => params[:uuid])
    render :json => {quiz: quiz, questions_count: quiz.questions.count}
  end

  def author
    render :json => Quiz.find_by(:uuid => params[:uuid]).author
  end

  def update
    quiz = Quiz.find_by(:uuid => params[:uuid])
    quiz.update!(:description => params[:description]) if params[:description]
    quiz.update!(:title => params[:title]) if params[:title]
    render :json => quiz
  end

  def destroy
    quiz = Quiz.find_by(:uuid => params[:uuid])
    quiz.destroy!
    render :json => {'message' => 'Deleted'}
  end
end
