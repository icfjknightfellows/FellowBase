class Airtable::UserWorker

  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform
    # Pass in api key to client
    client = Airtable::Client.new(ENV["AIRTABLE_API_KEY"])

    # Pass in the app key and table name
    table = client.table(ENV["AIRTABLE_APP_KEY"], "ref_users")

    records = table.all

    # Delete rows not in the system.
    records_in_system = User.where.not(role: "admin").select(:user_id).pluck(:user_id)
    records_in_response = records.map{|x| x["id"] }
    records_removed = records_in_system - records_in_response
    records_removed.each do |r|
      t = User.where(user_id: r).first.delete
    end

    records.each do |u|
      attrs = {
        user_id: u[:id],
        name: u[:name],
        email: u[:email],
        role: u[:role]
      }
      user = User.create_or_update(attrs)
    end
  end
end