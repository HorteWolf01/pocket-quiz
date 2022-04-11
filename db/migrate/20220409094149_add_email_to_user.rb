class AddEmailToUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :login, :string
    remove_column :users, :apitoken, :string
    add_column :users, :email, :string
  end
end
