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
  # has_many :trackable_metrics, primary_key: "digital_asset_id", foreign_key: "asset_id", dependent: :destroy

  #VALIDATIONS

  #CALLBACKS
  after_destroy :delete_item_from_channel
  before_create :add_item_to_impact_monitor

  before_update :add_item_to_impact_monitor
  before_update :update_asset_url_in_impact_monitor

  after_update  :initiate_tracker_worker

  #SCOPE
  scope :with_no_data, -> { where.not(custom_errors: "") }
  scope :with_data, -> { where(custom_errors: "") }
  scope :untracked, -> { where(tracked: false) }

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
        asset = DigitalAsset.create(attrs)
      end
      asset
    end
  end

  #PRIVATE
  private

    def delete_item_from_channel
      if self.tracked == true and self.item_id.present?
        response = ImpactMonitorApi.delete_item(self.item_id)
      end
      true
    end

    def add_item_to_impact_monitor
      if self.tracked == false or tracked.nil?
        impact_monitor_item = ImpactMonitorApi.add_monitored_item(self.asset)
        if impact_monitor_item["success"]
          item_obj = impact_monitor_item["items"]
          i_o = item_obj.first
          if i_o["success"]
            monitored_item_id = i_o["monitored_item_id"]
            self.item_id = monitored_item_id
            self.tracked = true
          else
            self.tracked = false
            self.custom_errors = "Impact Monitor: Could not add the link."
          end
        else
          self.tracked = false
          self.custom_errors = "Impact Monitor: Could not add the link."
        end
      end
      true
    end

    def update_asset_url_in_impact_monitor
      if self.asset_changed? and self.tracked == true
        response = ImpactMonitorApi.update_item(self.item_id, self.asset)
        if response["success"]
          return true
        else
          return false
        end
      end
      true
    end

    def initiate_tracker_worker
      if self.last_update_unixtime_changed? and self.tracked == true
        self.update_column(:custom_errors, "")
        self.update_column(:last_requested_unixtime, Time.now.to_i)
        # Initiate the workers.
        TrackableMetricSocialShareWorker.perform_at(1.second.from_now, self.item_id)
        TrackableMetricTwitterWorker.perform_at(2.second.from_now, self.item_id)
        ItemOverviewWorker.perform_at(3.second.from_now, self.item_id)
      end
      true
    end
end
