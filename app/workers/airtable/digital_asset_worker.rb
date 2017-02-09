class Airtable::DigitalAssetWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform
    # Pass in api key to client
    client = Airtable::Client.new(ENV["AIRTABLE_API_KEY"])

    # Pass in the app key and table name
    table = client.table(ENV["AIRTABLE_APP_KEY"], "digital_assets")

    records = table.all

    # Delete rows not in the system.
    records_in_system = DigitalAsset.select(:digital_asset_id).pluck(:digital_asset_id)
    records_in_response = records.map{|x| x[:id] }
    records_removed = records_in_system - records_in_response
    records_removed.each do |r|
      t = DigitalAsset.where(digital_asset_id: r).first.delete
    end

    records.each do |i|
      if i[:asset].present?
        attrs = {
          digital_asset_id: i[:id],
          asset: i[:asset],
          headline: i[:headline],
          genre: i[:genre],
          publication: i[:publication],
          event_id: i["event (events)"].first
        }
        asset = DigitalAsset.create_or_update(attrs)
      end
    end

    ImpactMonitorItemWorker.perform_at(1.second.from_now)
  end
end