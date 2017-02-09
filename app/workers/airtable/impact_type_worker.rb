class Airtable::ImpactTypeWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true


  def perform
    # Pass in api key to client
    client = Airtable::Client.new(ENV["AIRTABLE_API_KEY"])

    # Pass in the app key and table name
    table = client.table(ENV["AIRTABLE_APP_KEY"], "ref_impacts")

    records = table.all

    # Delete rows not in the system.
    records_in_system = RefImpactType.select(:ref_impact_type_id).pluck(:ref_impact_type_id)
    records_in_response = records.map{|x| x["id"] }
    records_removed = records_in_system - records_in_response
    records_removed.each do |r|
      t = RefImpactType.where(ref_impact_type_id: r).first.delete
    end

    records.each do |i|
      if i[:name].present?
        attrs = {
          ref_impact_type_id: i[:id],
          name: i[:name],
          genre: i[:genre]
        }
        impact_type = RefImpactType.create_or_update(attrs)
      end
    end
  end
end