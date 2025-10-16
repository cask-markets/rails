class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.string :area
      t.string :shelf
      t.string :position

      t.timestamps
    end
  end
end
