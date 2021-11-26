class AddPasswordDigestAndApitokenToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :login
      t.string :password_digest
      t.string :apitoken
    end
  end
end
