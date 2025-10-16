class User < ApplicationRecord
  has_secure_password

  has_many :owned_companies, class_name: "Company", foreign_key: :owner_id, dependent: :destroy
  has_many :owned_casks, class_name: "Cask", foreign_key: :owner_id, dependent: :destroy
  has_many :warehouse_staff_assignments, dependent: :destroy
  has_many :warehouses, through: :warehouse_staff_assignments
  has_many :relocation_requests, foreign_key: :requester_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
