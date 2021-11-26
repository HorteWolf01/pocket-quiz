class RenameTrueToRightInAnswer < ActiveRecord::Migration[6.1]
  def change
    change_table :answers do |t|
      t.rename :true?, :right
    end
  end
end
