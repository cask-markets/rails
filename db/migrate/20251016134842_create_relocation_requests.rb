class CreateRelocationRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :relocation_requests do |t|
      t.references :cask, null: false, foreign_key: true
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :from_location, null: false, foreign_key: { to_table: :locations }
      t.references :to_location, null: true, foreign_key: { to_table: :locations }
      t.integer :status, null: false, default: 0
      t.datetime :requested_at
      t.datetime :completed_at
      t.text :notes

      t.timestamps
    end
    add_index :relocation_requests, :status
  end
end
