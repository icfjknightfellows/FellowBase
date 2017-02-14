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

  after_update :update_dates, if: :last_update_unixtime_changed?
  after_update :initiate_tracker_worker, if: :last_update_unixtime_changed?

  after_update :upload_errors_to_airtable, if: :custom_errors_changed?

  before_update :update_asset_url_in_impact_monitor, if: :asset_changed?

  #FUNCTIONS

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
          asset.update_attribute(:last_requested_unixtime, Time.now.to_i)
          update_time(asset.digital_asset_id, asset.last_requested_unixtime, asset.last_requested_unixtime)
        end
      end
      asset
    end

    def update_time(asset_id, by_pykih, by_impact_monitor)
      # by_pykih and by_impact_monitor are timestamps.
      by_pykih = Time.at(by_pykih).to_datetime
      by_impact_monitor = Time.at(by_impact_monitor).to_datetime

      Airtable::UpdateDigitalAssetWorker.perform_at(1.second.from_now, asset_id, {
        "last update by pykih" => by_pykih,
        "last update by impact monitor" => by_impact_monitor,
      })
    end

    private

      def set_item_to_channel(asset_id, asset)
        impact_monitor_item = ImpactMonitorApi.add_monitored_item(asset)
        if impact_monitor_item["success"]
          item_obj = impact_monitor_item["items"]
          i_o = item_obj.first
          if i_o["success"]
            monitored_item_id = i_o["monitored_item_id"]
           Airtable::UpdateDigitalAssetWorker.perform_at(1.second.from_now, asset_id, {
              "tracked" => true
            })
            return { success: true, item_id: monitored_item_id }
          else
            Airtable::UpdateDigitalAssetWorker.perform_at(1.second.from_now, asset_id, {
              "tracked" => false,
              "errors" => "Could not add the link in impact monitor. Note: Mobile links are not allowed."
            })
            return { success: false }
          end
        else
          Airtable::UpdateDigitalAssetWorker.perform_at(1.second.from_now, asset_id, {
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
        Airtable::UpdateDigitalAssetWorker.perform_at(1.second.from_now, self.digital_asset_id, {
          "tracked" => false,
          "errors" => "Removing the item form the system."
        })
      end
      true
    end

    def update_asset_url_in_impact_monitor
      response = ImpactMonitorApi.update_item(self.item_id, self.asset)
      if response["success"]
        return true
      else
        return false
      end
      true
    end

    def update_dates
      self.update_column(:last_requested_unixtime, Time.now.to_i)
      DigitalAsset.update_time(self.digital_asset_id, self.last_requested_unixtime, self.last_update_unixtime)
      true
    end

    def initiate_tracker_worker
      # Initiate the workers.
      TrackableMetricSocialShareWorker.perform_at(1.second.from_now, self.item_id)
      TrackableMetricTwitterWorker.perform_at(2.second.from_now, self.item_id)
      ItemOverviewWorker.perform_at(3.second.from_now, self.item_id)
      true
    end

    def upload_errors_to_airtable
      Airtable::UpdateDigitalAssetWorker.perform_at(1.second.from_now, self.digital_asset_id, {
        "errors" => self.custom_errors
      })
      true
    end

end
