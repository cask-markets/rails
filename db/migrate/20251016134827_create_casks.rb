class CreateCasks < ActiveRecord::Migration[8.0]
  def change
    create_table :casks do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :location, null: false, foreign_key: true
      t.string :cask_number, null: false
      t.text :description
      t.string :spirit_type

      t.timestamps
    end
    add_index :casks, :cask_number
  end
end
