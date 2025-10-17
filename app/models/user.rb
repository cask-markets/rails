class User < ApplicationRecord
  has_many :owned_companies, class_name: "Company", foreign_key: :owner_id, dependent: :destroy
  has_many :owned_casks, class_name: "Cask", foreign_key: :owner_id, dependent: :destroy
  has_many :warehouse_staff_assignments, dependent: :destroy
  has_many :warehouses, through: :warehouse_staff_assignments
  has_many :relocation_requests, foreign_key: :requester_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :clerk_user_id, presence: true, uniqueness: true

  # Find or create user from Clerk user data
  def self.from_clerk(clerk_user)
    find_or_create_by(clerk_user_id: clerk_user["id"]) do |user|
      user.email = clerk_user["email_addresses"]&.first&.dig("email_address")
      user.name = [clerk_user["first_name"], clerk_user["last_name"]].compact.join(" ").presence || user.email
    end
  end

  # Sync user data from Clerk
  def sync_from_clerk(clerk_user)
    update(
      email: clerk_user["email_addresses"]&.first&.dig("email_address"),
      name: [clerk_user["first_name"], clerk_user["last_name"]].compact.join(" ").presence || email
    )
  end
end
