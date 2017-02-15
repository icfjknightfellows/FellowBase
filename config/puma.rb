workers Integer(ENV['WEB_CONCURRENCY'] || 2)

threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

app_dir = File.expand_path("../..", __FILE__)
preload_app!

rackup DefaultRackup

port ENV['PORT'] || 3000

rails_env = ENV['RAILS_ENV'] || 'development'

environment rails_env

# Bind
bind "unix://#{app_dir}/tmp/sockets/puma.sock"


# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"

activate_control_app

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end