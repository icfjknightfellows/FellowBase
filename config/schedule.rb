set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
every '* 1 * * *' do
  rake "jobs:hourly"
end

every '20 * * * *' do
  rake "jobs:refresh_mat_view"
end