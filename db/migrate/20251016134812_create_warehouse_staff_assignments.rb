class CreateWarehouseStaffAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouse_staff_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.integer :role
      t.boolean :can_move_casks

      t.timestamps
    end
  end
end
