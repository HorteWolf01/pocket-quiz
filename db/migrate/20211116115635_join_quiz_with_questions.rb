class JoinQuizWithQuestions < ActiveRecord::Migration[6.1]
  def change
    change_table :questions do |t|
      t.belongs_to :quiz
    end
  end
end
