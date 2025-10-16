class Location < ApplicationRecord
  belongs_to :warehouse
  has_many :casks, dependent: :restrict_with_error
  has_many :relocation_requests_from, class_name: "RelocationRequest", foreign_key: :from_location_id
  has_many :relocation_requests_to, class_name: "RelocationRequest", foreign_key: :to_location_id

  validates :area, presence: true
  validates :shelf, presence: true
  validates :position, presence: true

  def full_address
    "#{area}, Shelf #{shelf}, Position #{position}"
  end
end
