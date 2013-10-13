class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname
      t.string :login
      t.string :email
      t.string :crypted_password, limit: 40
      t.string :salt, limit: 40
      t.string :remember_token
      t.string :remember_token_expires_at
      t.string :website

      t.timestamps
    end
  end
end
