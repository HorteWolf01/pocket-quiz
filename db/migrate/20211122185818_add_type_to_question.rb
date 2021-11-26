class AddTypeToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :question_type, :int
    add_column :answers, :true?, :boolean
  end
end
