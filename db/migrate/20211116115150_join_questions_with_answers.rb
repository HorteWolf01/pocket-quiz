class JoinQuestionsWithAnswers < ActiveRecord::Migration[6.1]
  def change
    change_table :answers do |t|
      t.belongs_to :question
    end
  end
end
