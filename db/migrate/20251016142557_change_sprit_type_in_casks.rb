class ChangeSpritTypeInCasks < ActiveRecord::Migration[8.0]
  def change
    remove_column :casks, :spirit_type, :string
    add_reference :casks, :spirit_type, null: false, foreign_key: true
  end
end
