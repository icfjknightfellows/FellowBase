class ItemOverviewWorker

  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform(item_id)
    asset = DigitalAsset.find_by(item_id: item_id)
    asset_id = asset.digital_asset_id
    response = ImpactMonitorApi.get_overview(item_id)
    if response["success"]
      item_overview = response["overview"]

      #### ImpactMonitor Social Share
      TrackableMetric.create_or_update(item_id, asset_id, "impact_monitor", "social_score", item_overview["social_score"] || 0)

      #### ImpactMonitor Regular Share
      TrackableMetric.create_or_update(item_id, asset_id, "impact_monitor", "regular_score", item_overview["regular_score"] || 0)

      #### ImpactMonitor Estimated Views
      TrackableMetric.create_or_update(item_id, asset_id, "impact_monitor", "estimated_views", item_overview["estimated_views"] || 0)
    else
      errors = asset.custom_errors || ""
      errors = errors == "" ? "Impact Monitor: #{response["message"]} for social_score, regular_score and estimated_views." : "#{errors}\n\n Impact Monitor: #{response["message"]}  for social_score, regular_score and estimated_views."
      asset.update_attribute(:custom_errors, errors)
    end
  end
end