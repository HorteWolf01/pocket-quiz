class AddTitleToQuiz < ActiveRecord::Migration[6.1]
  def change
    add_column :quizzes, :title, :string
  end
end
