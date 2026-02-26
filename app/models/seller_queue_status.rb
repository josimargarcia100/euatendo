class SellerQueueStatus < ApplicationRecord
  belongs_to :store
  belongs_to :seller, class_name: "User"

  STATUSES = %w[idle attending paused].freeze

  validates :store_id, :seller_id, :status, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :active, -> { where.not(status: "paused") }
end
