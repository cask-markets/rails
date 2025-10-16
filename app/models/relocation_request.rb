class RelocationRequest < ApplicationRecord
  belongs_to :cask
  belongs_to :requester, class_name: "User"
  belongs_to :from_location, class_name: "Location"
  belongs_to :to_location, class_name: "Location", optional: true

  enum :status, { pending: 0, approved: 1, in_progress: 2, completed: 3, rejected: 4 }

  validates :status, presence: true
  validates :requested_at, presence: true

  before_validation :set_requested_at, on: :create

  private

  def set_requested_at
    self.requested_at ||= Time.current
  end
end
