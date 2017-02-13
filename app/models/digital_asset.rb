# == Schema Information
#
# Table name: digital_assets
#
#  id                   :integer          not null
#  digital_asset_id     :string           primary key
#  asset                :text
#  headline             :text
#  genre                :string
#  publication          :string
#  event_id             :string
#  item_id              :integer
#  _type                :string
#  creation_unixtime    :integer
#  last_update_unixtime :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
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
        response = set_item_to_channel(attrs[:asset])
        if response[:success]
          attrs[:item_id] = response[:item_id]
          asset = DigitalAsset.create(attrs)
          sleep 0.5.second
          TrackableMetricSocialShareWorker.perform_at(1.second.from_now, asset.item_id)
          TrackableMetricTwitterWorker.perform_at(2.second.from_now, asset.item_id)
          ItemOverviewWorker.perform_at(3.second.from_now, asset.item_id)
        end
      end
      asset
    end

    private

      def set_item_to_channel(asset)
        impact_monitor_item = ImpactMonitorApi.add_monitored_item(asset)
        if impact_monitor_item["success"]
          item_obj = impact_monitor_item["items"]
          i_o = item_obj.first
          if i_o["success"]
            monitored_item_id = i_o["monitored_item_id"]
            return { success: true, item_id: monitored_item_id }
          else
            puts "ERROR ADDING LINK: #{i_o}"
            return { success: false }
          end
        else
          puts "ERROR ADDING LINK: #{impact_monitor_item}"
          return { success: false }
        end
      end
  end

  #PRIVATE
  private

    def delete_item_from_channel
      if self.item_id.present?
        response = ImpactMonitorApi.delete_item(self.item_id)
        puts "Deleting Item from impact monitor: #{response}"
      end
      true
    end

    def initiate_tracker_worker
      if self.last_update_unixtime_changed?
        TrackableMetricSocialShareWorker.perform_at(1.second.from_now, self.item_id)
        TrackableMetricTwitterWorker.perform_at(2.second.from_now, self.item_id)
        ItemOverviewWorker.perform_at(3.second.from_now, self.item_id)
      end
      true
    end

end
