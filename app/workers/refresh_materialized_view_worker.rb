class RefreshMaterializedViewWorker

  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform
    Report.refresh
  end
end