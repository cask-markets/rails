class Company < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :warehouses, dependent: :destroy

  validates :name, presence: true
end
