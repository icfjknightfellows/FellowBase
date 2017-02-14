class Airtable::UpdateDigitalAssetWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(id, data)
    # Pass in api key to client.
    client = Airtable::Client.new(ENV["AIRTABLE_API_KEY"])

    # Pass in the app key and table name.
    table = client.table(ENV["AIRTABLE_APP_KEY"], "digital_assets")

    # Find the record with the given id.
    record = table.find(id)

    # Update data
    data.each do |k,v|
      record[k] = v
    end
    table.update(record)
  end
end