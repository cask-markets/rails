class AddClerkToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :clerk_user_id, :string
    add_index :users, :clerk_user_id, unique: true
    remove_column :users, :password_digest, :string
  end
end
