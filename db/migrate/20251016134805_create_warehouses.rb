class CreateWarehouses < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.text :address
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
