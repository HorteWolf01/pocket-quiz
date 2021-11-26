class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :time
      t.integer :points

      t.timestamps
    end
  end
end
