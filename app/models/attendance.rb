class Attendance < ApplicationRecord
  belongs_to :store
  belongs_to :seller, class_name: "User"

  RESULTS = %w[sale no_sale pending].freeze

  validates :store_id, :seller_id, :started_at, presence: true
  validates :result, inclusion: { in: RESULTS }, allow_nil: true

  scope :today, ->(store) { where(store_id: store, started_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :completed, -> { where.not(result: :pending) }
  scope :sales, -> { where(result: :sale) }
  scope :by_period, ->(start_date, end_date) { where(started_at: start_date..end_date) }

  def duration_minutes
    return nil unless ended_at
    ((ended_at - started_at) / 60).round(1)
  end

  def self.conversion_rate(store, start_date = nil, end_date = nil)
    scope = store.attendances.completed
    scope = scope.by_period(start_date, end_date) if start_date && end_date

    total = scope.count
    return 0 if total.zero?

    sales = scope.sales.count
    ((sales.to_f / total) * 100).round(1)
  end
end
