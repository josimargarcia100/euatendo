class SellerQueueStatus < ApplicationRecord
  belongs_to :store
  belongs_to :seller, class_name: "User"

  enum status: { idle: "idle", attending: "attending", paused: "paused" }

  validates :store_id, :seller_id, :status, presence: true

  scope :active, -> { where.not(status: :paused) }
end
