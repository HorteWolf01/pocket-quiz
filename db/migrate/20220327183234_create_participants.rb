class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
