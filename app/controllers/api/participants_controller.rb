class Api::ParticipantsController < ApplicationController
  def user
    user = User.find_by(:id => params[:id])
    mas = {}
    user.quizzes.each_with_index do |e, i|
      mas[i] = {:quiz => e, :score => Participant.find_by(:user_id => user.id, :quiz_id => e.id).score}
    end
    render :json => mas
  end

  def quiz
    quiz = Quiz.find_by(:uuid => params[:uuid])
    mas = {}
    quiz.users.each_with_index do |e, i|
      mas[i] = {:user => e, :score => Participant.find_by(:user_id => e.id, :quiz_id => quiz.id).score}
    end
    render :json => mas
  end
end
