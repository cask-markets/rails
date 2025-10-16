class Valuation < ApplicationRecord
  belongs_to :cask

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :valuation_date, presence: true
end
