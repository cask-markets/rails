class WarehouseStaffAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :warehouse

  enum :role, { staff: 0, manager: 1 }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :warehouse_id }
end
