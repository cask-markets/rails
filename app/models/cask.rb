class Cask < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :location
  has_one :warehouse, through: :location
  has_many :valuations, dependent: :destroy
  has_many :relocation_requests, dependent: :destroy

  validates :cask_number, presence: true, uniqueness: true
  validates :spirit_type, presence: true

  def current_valuation
    valuations.order(valuation_date: :desc).first
  end
end
