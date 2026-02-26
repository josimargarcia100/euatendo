class Store < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :seller_queue_statuses, dependent: :destroy

  validates :name, presence: true
  validates :cnpj, presence: true, uniqueness: true
  validates :timezone, presence: true, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
end
