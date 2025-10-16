class CreateValuations < ActiveRecord::Migration[8.0]
  def change
    create_table :valuations do |t|
      t.references :cask, null: false, foreign_key: true
      t.decimal :amount
      t.date :valuation_date
      t.text :notes

      t.timestamps
    end
  end
end
