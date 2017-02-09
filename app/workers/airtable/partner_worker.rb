class Airtable::PartnerWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true


  def perform
    # Pass in api key to client
    client = Airtable::Client.new(ENV["AIRTABLE_API_KEY"])

    # Pass in the app key and table name
    table = client.table(ENV["AIRTABLE_APP_KEY"], "ref_partners")

    records = table.all

    # Delete rows not in the system.
    records_in_system = RefPartner.select(:ref_partner_id).pluck(:ref_partner_id)
    records_in_response = records.map{|x| x["id"] }
    records_removed = records_in_system - records_in_response
    records_removed.each do |r|
      t = RefPartner.where(ref_partner_id: r).first.delete
    end

    records.each do |p|
      if p[:name].present?
        attrs = {
          ref_partner_id: p[:id],
          name: p[:name]
        }
        partner = RefPartner.create_or_update(attrs)
      end
    end
  end
end