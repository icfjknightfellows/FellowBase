class TrackableMetricSocialShareWorker

  include Sidekiq::Worker
  sidekiq_options backtrace: true


  def perform(item_id)
    asset = DigitalAsset.find_by(item_id: item_id)
    response = ImpactMonitorApi.get_social_shares(item_id)
    unless response["error"].present?
      #### Facebook Likes
      TrackableMetric.create_or_update(response["item_id"], asset.digital_asset_id, "facebook", "likes", response["facebook_likes"])

      #### Facebook shares
      TrackableMetric.create_or_update(response["item_id"], asset.digital_asset_id, "facebook", "shares", response["facebook_shares"])

      #### Facebook Comments
      TrackableMetric.create_or_update(response["item_id"], asset.digital_asset_id, "facebook", "comments", response["facebook_comments"])

      #### Twitter Mentions
      TrackableMetric.create_or_update(response["item_id"], asset.digital_asset_id, "twitter", "mentions", response["twitter_mentions"])

      #### Google Shares
      TrackableMetric.create_or_update(response["item_id"], asset.digital_asset_id, "google", "shares", response["google_shares"])
    end
  end

end