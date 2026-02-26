class CleanupStaleAttendancesJob < ApplicationJob
  queue_as :default

  # Find and close attendances that have been active for more than 4 hours
  def perform(*args)
    # Find all incomplete attendances that started more than 4 hours ago
    stale_limit = 4.hours.ago

    stale_attendances = Attendance.where(result: nil)
                                  .where("started_at < ?", stale_limit)
                                  .where("ended_at IS NULL")

    count = 0
    stale_attendances.each do |attendance|
      # Auto-close the attendance as "pending" since we don't know the result
      attendance.update(
        ended_at: Time.current,
        result: "pending"
      )

      # Reset the seller's queue status back to idle
      queue_status = SellerQueueStatus.find_by(
        store: attendance.store,
        seller: attendance.seller
      )
      if queue_status && queue_status.status == "attending"
        queue_status.update(status: "idle")
      end

      count += 1
    end

    puts "[CleanupStaleAttendancesJob] Closed #{count} stale attendances"
  end
end
