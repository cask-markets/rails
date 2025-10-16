class Warehouse < ApplicationRecord
  belongs_to :company
  has_many :locations, dependent: :destroy
  has_many :casks, through: :locations
  has_many :warehouse_staff_assignments, dependent: :destroy
  has_many :staff_members, through: :warehouse_staff_assignments, source: :user

  validates :name, presence: true
  validates :address, presence: true
end
