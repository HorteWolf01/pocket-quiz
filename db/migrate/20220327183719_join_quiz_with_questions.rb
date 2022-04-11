class JoinQuizWithQuestions < ActiveRecord::Migration[7.0]
  def change
    change_table :questions do |t|
      t.belongs_to :quiz
    end
  end
end
