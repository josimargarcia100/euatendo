class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[seller manager owner].freeze

  has_many :stores, dependent: :destroy
  has_many :attendances, foreign_key: :seller_id, dependent: :destroy
  has_many :seller_queue_statuses, foreign_key: :seller_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }

  def seller?
    role == "seller"
  end

  def manager?
    role == "manager"
  end

  def owner?
    role == "owner"
  end
end
