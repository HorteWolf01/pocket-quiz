class JoinQuestionsWithAnswers < ActiveRecord::Migration[7.0]
  def change
    change_table :answers do |t|
      t.belongs_to :question
    end
  end
end
