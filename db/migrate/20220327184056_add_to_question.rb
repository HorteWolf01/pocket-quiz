class AddToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :question_type, :integer
    add_column :answers, :right, :boolean
  end
end
