desc 'Run cleanup jobs'
task scheduler: :environment do
  puts '[Scheduler] Running cleanup jobs...'
  CleanupStaleAttendancesJob.perform_now
  puts '[Scheduler] Cleanup jobs completed'
end

namespace :scheduler do
  desc 'Run jobs once'
  task run_once: :environment do
    Rake::Task['scheduler'].invoke
  end
end
