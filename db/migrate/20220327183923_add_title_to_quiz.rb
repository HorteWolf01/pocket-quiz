class AddTitleToQuiz < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :title, :string
  end
end
