class Api::QuestionsController < ApplicationController
  def index
    render :json => Quiz.find_by(:uuid => params[:uuid]).questions
  end
  
  def show
    unless question = Quiz.find_by(:uuid => params[:uuid]).questions[params[:q].to_i]
      return render :json => {'messge' => 'Question not found'}
    else
      if question.question_type == 'False' or question.question_type == 'True'
        render :json => {:question => question}
        return
      end
    end
    render :json => {:question => question, :answers => question.answers}
  end

  def destroy
    question = Quiz.find_by(:uuid => params[:uuid]).questions[params[:q].to_i]
    question.answers.each {|e| e.destroy}
    question.destroy
    render :json => {:messge => "Deleted"}
  end

  def add
    #params: 
      #:uuid  
      #:points - optional, default 1
      #:text
      #:question_type: 'Multiple choice', 'Fill in the blank', 'Multiple answer', 'True', 'False', 'Numeric'
      #:answer - required for 'Multiple choice', 'Numeric' - right answer, 'Fill in the blank' - showed answer

    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    else
      unless params[:question_type] and params[:question_type].in? Question::question_types
        return render :json => {'message' => 'Wrong params, need question_type, available types: Multiple choice, Fill in the blank, Multiple answer, True, False, Numeric'}
      else
        unless params[:text]
          return render :json => {'message' => 'Wrong params, need text'}
        else
          case params[:question_type]
          when 'True', 'False'
            quiz.questions.create!(:text => params[:text], :question_type => params[:question_type], :points => params[:points])
            return render :json => Quiz.find_by(:uuid => params[:uuid]).questions.last
          when 'Multiple choice', 'Fill in the blank'
            unless params[:answer]
              return render :json => {'message' => 'Wrong params, need answer'}
            else 
              q = quiz.questions.create!(:text => params[:text], :question_type => params[:question_type], :points => params[:points])
              q.answers.create!(:text => params[:answer], :right => true)
              return render :json => Quiz.find_by(:uuid => params[:uuid]).questions.last
            end
          when 'Numeric'
            unless params[:answer] and params[:answer].numeric?
              return render :json => {'message' => 'Wrong params, need numeric answer'}
            else
              q = quiz.questions.create!(:text => params[:text], :question_type => params[:question_type], :points => params[:points])
              q.answers.create!(:text => params[:answer].to_f.to_s, :right => true)
              return render :json => Quiz.find_by(:uuid => params[:uuid]).questions.last
            end
          else
            quiz.questions.create!(:text => params[:text], :question_type => params[:question_type], :points => params[:points])
            return render :json => Quiz.find_by(:uuid => params[:uuid]).questions.last
          end
        end
      end
    end
      render :json => {'message' => 'Internal error'}
  end

  def add_answer
    #params:
      #:uuid
      #:q - question number in quiz
      #:text
      #:right - required for 'Multiple answer' type
    #question types: 'Multiple answer' - additional answers, 'Multiple choice' - false answers, 'Fill in the blank' - answer variants

    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    else
      unless q = quiz.questions[params[:q].to_i]
        return render :json => {'message' => 'Question not found'}
      else
        case q.question_type
        when 'Multiple answer'
          unless params[:text]
            return render :json => {'message' => 'Wrong params, need text'}
          else
            unless params[:right]
              return render :json => {'message' => 'Wrong params, need right'}
            else
              q.answers.create!(:text => params[:text], :right => params[:right].to_bool)
            end
          end
        when 'Multiple choice', 'Fill in the blank'
          unless params[:text]
            return render :json => {'message' => 'Wrong params, need text'}
          else
            q.answers.create!(:text => params[:text], :right => false)
          end
        else
          return render :json => {'message' => 'Unavailable for this question type'}
        end
      end
    end
    render :json => Quiz.find_by(:uuid => params[:uuid]).questions[params[:q].to_i].answers.last
  end

  def update_answer
    #params:
      #:uuid
      #:q - question number in quiz
      #:a - answer number in question
      #:text
      #:right - required for 'Multiple answer' type
    #question types: 'Multiple answer', 'Multiple choice', 'Fill in the blank', 'Numeric', 'True', 'False'

    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    else
      unless q = quiz.questions[params[:q].to_i]
        return render :json => {'message' => 'Question not found'}
      else
        case q.question_type
        when 'True', 'False'
          unless params[:right]
            unless params[:text]
              return render :json => {'messge' => 'Wrong params, need text or right'}
            else
              unless q.question_type.to_bool == params[:text].to_bool
                unless params[:text].to_bool
                  q.update!(:question_type => 'False')
                else
                  q.update!(:question_type => 'True')
                end
              end
            end
          else
            unless q.question_type.to_bool == params[:right].to_bool
              unless params[:right].to_bool
                q.update!(:question_type => 'False')
              else
                q.update!(:question_type => 'True')
              end
            end
          end
          return render :json => {'answer' => q.question_type}
        when 'Multiple answer'
          unless params[:text] or params[:right]
            return render :json => {'message' => 'Wrong params, need text and/or right'}
          else
            q.answers[params[:a].to_i].update!(:text => params[:text]) if params[:text]
            q.answers[params[:a].to_i].update(:right => params[:right].to_bool) if params[:right]
          end
        when 'Multiple choice', 'Fill in the blank'
          unless params[:text]
            return render :json => {'message' => 'Wrong params, need text'}
          else
            q.answers[params[:a].to_i].update!(:text => params[:text])
          end
        when 'Numeric'
          unless params[:text] and params[:text].numeric?
            return render :json => {'message' => 'Wrong params, need numeric text'}
          else
            q.answers[params[:a].to_i].update!(:text => params[:text].to_f.to_s)
          end
        end
      end
    end
    render :json => Quiz.find_by(:uuid => params[:uuid]).questions[params[:q].to_i].answers[params[:a].to_i]
  end

  def destroy_answer
    #params:
      #:uuid
      #:q - question number in quiz
      #:a - answer number in quiz
    #question types: 'Multiple answer' - additional answers, 'Multiple choice' - false answers, 'Fill in the blank' - answer variants

    unless quiz = Quiz.find_by(:uuid => params[:uuid])
      return render :json => {'message' => 'Quiz not found'}
    else
      unless q = quiz.questions[params[:q].to_i]
        return render :json => {'message' => 'Question not found'}
      else
        case q.question_type
        when 'Multiple answer', 'Fill in the blank', 'Multiple choice'
          unless params[:a].to_i > 0
            return render :json => {'message' => 'Can\'t delete 0 answer'}
          else
            unless a = q.answers[params[:a].to_i]
              return render :json => {'messge' => 'Answer not found'}
            else
              a.destroy
              render :json => {'messge' => 'Deleted'}
            end
          end
        else
          return render :json => {'message' => 'Unavailable for this question type'}
        end
      end
    end
  end

  def show_answer
    question = Quiz.find_by(:uuid => params[:uuid]).questions[params[:q].to_i]
    if question.question_type.in? ['True', 'False']
      render :json => question.question_type
    else
    render :json => question.answers[params[:a].to_i]
    end
  end

end
