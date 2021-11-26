class QuizzesController < ApplicationController
  def question
    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    end
    unless q = quiz.questions[params[:q].to_i]      
      return render :json => {'message' => 'Question not found'}
    end
    ans = {}
    q.answers.shuffle.each_with_index do |a, i|
      ans[i] = {"id": a.id, "answer": a.text}
    end
    if q.question_type.in? ['True', 'False']
      render :json => {'question' => q.text, 'question_type' => 'True/false', 'points' => q.points, 'answers' => ans}
    else
      render :json => {'question' => q.text, 'question_type' => q.question_type, 'points' => q.points, 'answers' => ans}
    end
  end

  def connect
    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    end
    unless @@User
      return render :json => {:message => "You're not authorized"}
    else
      unless quiz.users.find_by(:id => @@User.id)
        quiz.users << @@User
      end
    end
    p request.host_with_port
    redirect_to "/#{params[:uuid]}/0"
  end

  def send_answer
    #params:
      #answer:  
        #for 'Multiple choice' type - answer id 
        #for 'Fill in the blank' type - text
        #for 'Multiple answer' type - set of answer ids like '1,2,3,4'
        #for 'True', 'False' types - 'true' or 'false'
        #for 'Numeric' type - numeric text
    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    end
    unless @@User
      return render :json => {:message => 'You\'re not authorized'}
    end
    unless quiz.users.find_by(:id => @@User.id)
      redirect_to "/#{params[:uuid]}"
    else
      participant = quiz.participants.find_by(:user_id => @@User.id, :quiz_id => quiz.id)
    end
    unless q = quiz.questions[params[:q].to_i]
      return render :json => {'message' => 'Question not found'}
    end
    outp = {}
    case q.question_type
    when 'Multiple choice'
      outp[:right_answer] = q.answers.first.text
      if Answer.find_by(:id => params[:answer].to_i).right
        outp[:result] = 'right'
        participant.score += q.points
        outp[:points] = q.points
      else
        outp[:result] = 'wrong'
        outp[:points] = 0
      end
    when 'Fill in the blank'
      outp[:right_answer] = q.answers.first.text
      if q.answers.find_by(:text => params[:answer])
        outp[:result] = 'right'
        participant.score += q.points
        outp[:points] = q.points
      else
        outp[:result] = 'wrong'
        outp[:points] = 0
      end
    when 'Multiple answer'
      right_text = []
      right_ids = []
      q.answers.each do |e|
        if e.right
          right_text << e.text
          right_ids << e.id
        end
      end
      outp[:right_answer] = right_text
      answer_ids = params[:answer].split ','
      answer_ids.map! {|e| e.to_i}      
      answer_ids.sort!
      right_ids.sort!
      if answer_ids == right_ids
        outp[:result] = 'right'
        participant.score += q.points
        outp[:points] = q.points
      else
        outp[:result] = 'wrong'
        outp[:points] = 0
      end
    when 'True', 'False'
      outp[:right_answer] = q.question_type.to_bool
      if params[:answer].to_bool == q.question_type.to_bool
        outp[:result] = 'right'
        participant.score += q.points
        outp[:points] = q.points
      else
        outp[:result] = 'wrong'
        outp[:points] = 0
      end
    when 'Numeric'
      if params[:answer].numeric?
        outp[:right_answer] = q.answers.first.text
        if params[:answer].to_f.to_s == q.answers.first.text
          outp[:result] = 'right'
          participant.score += q.points
          outp[:points] = q.points
        else
          outp[:result] = 'wrong'
          outp[:points] = 0
        end
      else
        return render :json => {'message' => 'Answer should be numeric!'}
      end
    end
    if params[:q].to_i < quiz.questions.count - 1
      outp[:next_question_url] = "#{request.host_with_port}/#{params[:uuid]}/#{params[:q].to_i + 1}"
    else
      outp[:results_url] = "#{request.host_with_port}/#{params[:uuid]}/results"
    end
    participant.save
    render :json => outp
  end

  def results
    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    end
    unless @@User
      return render :json => {:message => 'You\'re not authorized'}
    end
    unless quiz.users.find_by(:id => @@User.id)
      redirect_to "/#{params[:uuid]}"
    else
      participant = quiz.participants.find_by(:user_id => @@User.id, :quiz_id => quiz.id)
    end
    max_score = 0
    quiz.questions.each {|e| max_score += e.points}
    render :json => {'message' => "Congratulations, you scored #{participant.score} out of #{max_score} points!", 'score' => participant.score, 'max_score' => max_score}
  end
end
