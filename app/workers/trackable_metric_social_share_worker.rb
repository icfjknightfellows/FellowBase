class TrackableMetricSocialShareWorker

  include Sidekiq::Worker
  sidekiq_options backtrace: true


  def perform(item_id)
    asset = DigitalAsset.find_by(item_id: item_id)
    asset_id = asset.digital_asset_id
    response = ImpactMonitorApi.get_social_shares(item_id)

    unless response["error"].present?
      #### Facebook Likes
      TrackableMetric.create_or_update(item_id, asset_id, "facebook", "likes", response["facebook_likes"])

      #### Facebook shares
      TrackableMetric.create_or_update(item_id, asset_id, "facebook", "shares", response["facebook_shares"])

      #### Facebook Comments
      TrackableMetric.create_or_update(item_id, asset_id, "facebook", "comments", response["facebook_comments"])

      #### Twitter Mentions
      TrackableMetric.create_or_update(item_id, asset_id, "twitter", "mentions", response["twitter_mentions"])

      #### Google Shares
      TrackableMetric.create_or_update(item_id, asset_id, "google", "shares", response["google_shares"])
    else
      errors = asset.custom_errors || ""
      errors = errors == "" ? "Impact Monitor: #{response["message"]} (item: social_shares API)" : "#{errors}\n\n Impact Monitor: #{response["message"]} (item: social_shares API)"
      asset.update_attribute(:custom_errors, errors)
    end
  end

end