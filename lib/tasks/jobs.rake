namespace :jobs do
  desc 'Jobs to fetch application data into the system.'
  task :hourly  => :environment do
    HourlyWorker.perform_async
  end

  desc "Refresh materialized view"
  task :refresh_mat_view => :environment do
    RefreshMaterializedViewWorker.perform_async
  end
end