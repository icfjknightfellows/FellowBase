class HourlyWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform
    Airtable::ProjectWorker.perform_at(1.second.from_now)
    Airtable::ImpactTypeWorker.perform_at(3.second.from_now)
    Airtable::DigitalAssetWorker.perform_at(5.second.from_now)
    Airtable::PartnerWorker.perform_at(7.second.from_now)
    Airtable::UserWorker.perform_at(9.second.from_now)
  end

end