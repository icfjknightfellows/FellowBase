class ImpactMonitorItemWorker

  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform
    response = ImpactMonitorApi.list_channel_items
    if response["success"]
      items = response["items"]
      # begin
        items.each do |i|
          _i = DigitalAsset.where({
            item_id: i["monitored_item_id"]
          }).first

          if _i.present?
            _i.update_attributes({
              _type: i["type"],
              creation_unixtime: i["creation_unixtime"],
              last_update_unixtime: i["last_update_unixtime"]
            })
          end
        end
      # rescue Exception => e
      #   puts "Item #{e}"
      # end
    end
  end
end