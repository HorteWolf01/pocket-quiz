class AddTextToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :text, :string
  end
end
