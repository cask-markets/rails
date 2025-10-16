class SpiritType < ApplicationRecord
  has_many :casks, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
