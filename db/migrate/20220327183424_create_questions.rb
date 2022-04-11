class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.integer :time
      t.integer :points

      t.timestamps
    end
  end
end
