class QuizzesController < ApplicationController
  #require Responce

  def index
    @quizzes = Quiz.all
  rescue => e
    flash[:notice] = e.message
  end

  def new

  end

  def show
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions
  rescue => e
    flash[:notice] = e.message
  end

  def create
    user = User.last
    quiz = user.authored_quizzes.create!(
      params[:quiz].permit(
        :title,
        :description
      )
    )
    redirect_to quiz
  rescue => e
    flash[:notice] = e.message
  end

  def connect
    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :plain => "404, Not found", :status => :not_found
    end
    unless $user
      return render :json => {:message => "You're not authorized"}
    end
    unless quiz.users.find_by(:id => $user.id)
      quiz.users << $user
    end
    quiz.participants.find_by(:user_id => $user.id).update!(:score => 0)
    redirect_to "/#{params[:uuid]}/0"
  rescue => e
    flash[:notice] = e.message
  end

  def question
    unless @quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :plain => "404, Quiz not found", :status => :not_found
    end
    unless @question = @quiz.questions[params[:q].to_i]
      return render :plain => "404, Question not found", :status => :not_found
    end
    @answers = @question.answers.shuffle
  rescue => e
    flash[:notice] = e.message
  end

  def send_answer
    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    end
    unless $user
      return render :json => {:message => 'You\'re not authorized'}
    end
    unless quiz.users.find_by(:id => $user.id)
      redirect_to "/#{params[:uuid]}"
    else
      participant = quiz.participants.find_by(:user_id => $user.id, :quiz_id => quiz.id)
    end
    unless @q = quiz.questions[params[:q].to_i]
      return render :json => {'message' => 'Question not found'}
    end
    @outp = {}
    p 'DEBUG'
    p @q.question_type
    case @q.question_type
    when 'Multiple choice'
      @outp[:right_answer] = @q.answers.find_by(:right => true).text
      if Answer.find_by(:id => params[:answer][:ans].to_i).right
        @outp[:result] = 'right'
        participant.score += @q.points
        @outp[:points] = @q.points
      else
        @outp[:result] = 'wrong'
        @outp[:points] = 0
      end
    when 'Fill in the blank'
      @outp[:right_answer] = @q.answers.find_by(:right => true).text
      if @q.answers.find_by(:text => params[:answer][:ans])
        @outp[:result] = 'right'
        participant.score += @q.points
        @outp[:points] = @q.points
      else
        @outp[:result] = 'wrong'
        @outp[:points] = 0
      end
    when 'Multiple answer'
      p params[:answer]
      right = {}
      @q.answers.each do |e|
        if e.right
          right["#{e.id}"] = "1"
        else
          right["#{e.id}"] = "0"
        end
      end
      @outp[:right_answer] = right
      if params[:answer] == right
        @outp[:result] = 'right'
        participant.score += @q.points
        @outp[:points] = @q.points
      else
        @outp[:result] = 'wrong'
        @outp[:points] = 0
      end
    when 'True', 'False'
      @outp[:right_answer] = @q.question_type.to_bool
      if params[:answer][:ans].to_bool == @q.question_type.to_bool
        @outp[:result] = 'right'
        participant.score += @q.points
        @outp[:points] = @q.points
      else
        @outp[:result] = 'wrong'
        @outp[:points] = 0
      end
    when 'Numeric'
      if params[:answer][:ans].numeric?
        @outp[:right_answer] = @q.answers.first.text
        if params[:answer][:ans].to_f == @q.answers.first.text.to_f
          @outp[:result] = 'right'
          participant.score += @q.points
          @outp[:points] = @q.points
        else
          @outp[:result] = 'wrong'
          @outp[:points] = 0
        end
      else
        return render :json => {'message' => 'Answer should be numeric!'}
      end
    end
    if params[:q].to_i < quiz.questions.count - 1
      @outp[:next_question] = "#{params[:q].to_i + 1}"
    else
      @outp[:results_url] = true
    end
    participant.save
  rescue => e
    flash[:notice] = e.message
  end

  def results
    unless @quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    end
    unless $user
      return render :json => {:message => 'You\'re not authorized'}
    end
    unless @quiz.users.find_by(:id => $user.id)
      redirect_to "/#{params[:uuid]}"
    else
      @participant = @quiz.participants.find_by(:user_id => $user.id, :quiz_id => @quiz.id)
    end
    @max_score = 0
    @quiz.questions.each {|e| @max_score += e.points}
    @leaders = @quiz.participants.sort_by{|pt| 0 - pt.score}[0..9]
  rescue => e
    flash[:notice] = e.message
  end

  def certificate
    quiz = Quiz.find_by(:uuid => params[:uuid])
    participant = quiz.participants.find_by(:user_id => $user.id, :quiz_id => quiz.id)
    render :json => participant.updated_at
  end
end
