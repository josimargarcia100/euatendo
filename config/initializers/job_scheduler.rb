# Schedule background jobs
if Rails.env.production? || ENV['ENABLE_JOB_SCHEDULER'] == 'true'
  # Schedule cleanup job to run every hour
  class JobScheduler
    def self.schedule_jobs
      # This would be triggered by the Solid Queue worker
      # For development, use: bundle exec rake scheduler:work
    end
  end
end
