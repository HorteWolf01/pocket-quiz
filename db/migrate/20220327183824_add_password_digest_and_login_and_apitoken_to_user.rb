class AddPasswordDigestAndLoginAndApitokenToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :login
      t.string :password_digest
      t.string :apitoken
    end
  end
end
