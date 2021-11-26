class JoinUserWithQuiz < ActiveRecord::Migration[6.1]
  def change
    change_table :participants do |t|
      t.belongs_to :user
      t.belongs_to :quiz
    end

    change_table :quizzes do |t|
      t.belongs_to :author, class_name: "User"
    end
  end
end
