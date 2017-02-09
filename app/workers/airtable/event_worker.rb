class Airtable::EventWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true


  def perform
    # Pass in api key to client
    client = Airtable::Client.new(ENV["AIRTABLE_API_KEY"])

    # Pass in the app key and table name
    table = client.table(ENV["AIRTABLE_APP_KEY"], "events")

    records = table.all

    # Delete rows not in the system.
    records_in_system = Event.select(:event_id).pluck(:event_id)
    records_in_response = records.map{|x| x["id"] }
    records_removed = records_in_system - records_in_response
    records_removed.each do |r|
      t = Event.where(event_id: r).first.delete
    end

    records.each do |e|
      if e[:description].present?
        attrs = {
          event_id: e[:id],
          description: e[:description],
          project_ids: e[:projects],
          impact_type_ids: e[:ref_impact_types],
          media: e[:media],
          topics: e[:topics]
        }
        event = Event.create_or_update(attrs)
      end
    end
  end
end