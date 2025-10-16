class CreateSpiritTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :spirit_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :spirit_types, :name, unique: true
  end
end
