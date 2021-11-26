class CreateQuizzes < ActiveRecord::Migration[6.1]
  def change
    create_table :quizzes do |t|
      t.string :description
      t.string :uuid

      t.timestamps
    end
  end
end
