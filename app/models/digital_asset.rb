# == Schema Information
#
# Table name: digital_assets
#
#  id                      :integer          not null
#  digital_asset_id        :string           primary key
#  asset                   :text
#  headline                :text
#  genre                   :string
#  publication             :string
#  event_id                :string
#  item_id                 :integer
#  _type                   :string
#  creation_unixtime       :integer
#  last_update_unixtime    :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  last_requested_unixtime :integer
#  custom_errors           :text
#  tracked                 :boolean
#

class DigitalAsset < ActiveRecord::Base
  #GEMS
  self.primary_key = "digital_asset_id"
  #ATTRIBUTES
  #ASSOCIATIONS
  # has_many :trackable_metrics, primary_key: "digital_asset_id", foreign_key: "digital_asset_id", dependent: :destroy
  #VALIDATIONS
  #CALLBACKS
  after_destroy :delete_item_from_channel
  after_update :initiate_tracker_worker
  after_update :upload_errors_to_airtable
  #FUNCTIONS

  def update_last_requested_unixtime
    self.last_requested_unixtime = Time.now.to_i
    self.save
  end

  class << self
    def create_or_update(attrs)
      asset = DigitalAsset.where(digital_asset_id: attrs[:digital_asset_id]).first
      unless asset.blank?
        # Update
        asset = asset.update_attributes(
          asset: attrs[:asset],
          headline: attrs[:headline],
          genre: attrs[:genre],
          publication: attrs[:publication],
          event_id: attrs[:event_id]
        )
      else
        # Create
        attrs[:tracked] = true;
        response = set_item_to_channel(attrs[:digital_asset_id], attrs[:asset])
        if response[:success]
          attrs[:item_id] = response[:item_id]
          asset = DigitalAsset.create(attrs)
          sleep 0.5.second
          TrackableMetricSocialShareWorker.perform_at(1.second.from_now, asset.item_id)
          TrackableMetricTwitterWorker.perform_at(2.second.from_now, asset.item_id)
          ItemOverviewWorker.perform_at(3.second.from_now, asset.item_id)

          # Update the airtable data.
          asset.update_last_requested_unixtime
          updated_at = Time.at(asset.last_requested_unixtime).to_datetime
          update_time(asset.digital_asset_id, updated_at, updated_at)
        end
      end
      asset
    end

    def update_time(asset_id, by_pykih, by_impact_monitor)
      update_record_in_airtable(asset_id, {
        "last_update_by_pykih" => by_pykih,
        "last_update_by_impact_monitor" => by_impact_monitor,
      })
    end

    def update_record_in_airtable(id, data)
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

    private

      def set_item_to_channel(asset_id, asset)
        impact_monitor_item = ImpactMonitorApi.add_monitored_item(asset)
        if impact_monitor_item["success"]
          item_obj = impact_monitor_item["items"]
          i_o = item_obj.first
          if i_o["success"]
            monitored_item_id = i_o["monitored_item_id"]
            update_record_in_airtable(asset_id, {
              "tracked" => true
            })
            return { success: true, item_id: monitored_item_id }
          else
            update_record_in_airtable(asset_id, {
              "tracked" => false,
              "errors" => "Could not add the link in impact monitor. Note: Mobile links are not allowed."
            })
            return { success: false }
          end
        else
          update_record_in_airtable(asset_id, {
            "tracked" => false,
            "errors" => "Could not add the link in impact monitor.  Note: Mobile links are not allowed."
          })
          return { success: false }
        end
      end
  end

  #PRIVATE
  private

    def delete_item_from_channel
      if self.item_id.present?
        response = ImpactMonitorApi.delete_item(self.item_id)
        update_record_in_airtable(self.digital_asset_id, {
          "tracked" => false,
          "errors" => "Removing the item form the system."
        })
      end
      true
    end

    def initiate_tracker_worker
      if self.last_update_unixtime_changed?
        # Updating dates in airtable.
        self.update_last_requested_unixtime
        by_pykih = Time.at(self.last_requested_unixtime).to_datetime
        by_impact_monitor = Time.at(self.last_update_unixtime).to_datetime
        DigitalAsset.update_time(self.digital_asset_id, by_pykih, by_impact_monitor)

        # Initiate the workers.
        TrackableMetricSocialShareWorker.perform_at(1.second.from_now, self.item_id)
        TrackableMetricTwitterWorker.perform_at(2.second.from_now, self.item_id)
        ItemOverviewWorker.perform_at(3.second.from_now, self.item_id)
      end
      true
    end

    def upload_errors_to_airtable
      if self.custom_errors_changed?
        DigitalAsset.update_record_in_airtable(self.digital_asset_id, {
          "errors" => self.custom_errors
        })
      end
      true
    end

end
