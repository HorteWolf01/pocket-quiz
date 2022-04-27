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

  def export
    quiz = Quiz.find_by(:uuid => params[:uuid])
    questions = quiz.questions.map do |question|
      answers = question.answers.map do |answer|
        answer.attributes.except("id", "created_at", "updated_at", "question_id")
      end
      question.attributes.
        except("id", "time", "created_at", "updated_at", "quiz_id").
        merge(:answers => answers)
    end
    file = File.new("quiz.json", "w+")
    file.print(
      quiz.attributes.
      except("id", "uuid", "created_at", "updated_at", "author_id").
      merge(:questions => questions).to_json    
    )
    file.close
    send_file "quiz.json", :type => 'application/json'
  end

  def import_page

  end

  def import
    data = JSON.parse(params[:quiz][:file].read)
    quiz = Quiz.new(
      :description => data["description"],
      :title => data["title"],
      :author_id => $user.id
    )
    data["questions"].each do |question|
      q = quiz.questions.new(
        :points => question["points"],
        :text => question["text"],
        :question_type => question["question_type"]
      )
      question["answers"].each do |answer|
        q.answers.new(
          :text => answer["text"],
          :right => answer["right"]
        )
      end
    end
    quiz.save!
    redirect_to "/editor/quizzes/#{quiz.uuid}"
  end
end
