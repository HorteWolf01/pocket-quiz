class Editor::QuizzesController < ApplicationController
  def index 
    if $user.admin
      @quizzes = Quiz.all
    else
      @quizzes = Quiz.where(:author_id => $user.id)
    end
  rescue => e
    flash[:notice] = e.message
  end

  def new
  
  end

  def create
    quiz = Quiz.create!(
      params[:quiz].permit(
        :title,
        :description
      ).merge(:author_id => $user.id)
    )
    redirect_to "/editor/quizzes/#{quiz.uuid}"
  rescue => e
    flash[:notice] = e.message
  end

  def show
    @quiz = Quiz.find_by(:uuid => params[:uuid])
    @questions = @quiz.questions
  rescue => e
    flash[:notice] = e.message
  end
  
  def edit
    @quiz = Quiz.find_by(:uuid => params[:uuid])
  rescue => e
    flash[:notice] = e.message
  end

  def update
    quiz = Quiz.find_by(:uuid => params[:uuid])
    quiz.update!(
      params[:quiz].permit(
        :title,
        :description,
        :author_id
      )
    )
    redirect_to "/editor/quizzes/#{quiz.uuid}"
  rescue => e
    flash[:notice] = e.message
  end

  def destroy
    Quiz.find_by(:uuid => params[:uuid]).destroy!
    redirect_to "/editor/quizzes"
  rescue => e
    flash[:notice] = e.message
  end
end
