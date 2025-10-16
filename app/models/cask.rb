class Cask < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :location
  belongs_to :spirit_type
  has_one :warehouse, through: :location
  has_many :valuations, dependent: :destroy
  has_many :relocation_requests, dependent: :destroy

  validates :cask_number, presence: true, uniqueness: true

  def current_valuation
    valuations.order(valuation_date: :desc).first
  end
end
