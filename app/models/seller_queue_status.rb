class SellerQueueStatus < ApplicationRecord
  belongs_to :store
  belongs_to :seller
end
