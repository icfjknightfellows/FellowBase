class Airtable::ProjectWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true


  def perform
    # Pass in api key to client
    client = Airtable::Client.new(ENV["AIRTABLE_API_KEY"])

    # Pass in the app key and table name
    table = client.table(ENV["AIRTABLE_APP_KEY"], "projects")

    records = table.all

    # Delete rows not in the system.
    records_in_system = Project.select(:project_id).pluck(:project_id)
    records_in_response = records.map{|x| x["id"] }
    records_removed = records_in_system - records_in_response
    records_removed.each do |r|
      t = Project.where(project_id: r).first.delete
    end

    records.each do |p|
      if p[:name].present?
        attrs = {
          project_id: p[:id],
          name: p[:name],
          user_ids: p[:fellows],
          partner_ids: p["partners_(ref_partners)"]
        }
        project = Project.create_or_update(attrs)
      end
    end

    Airtable::EventWorker.perform_at(2.second.from_now)
  end
end