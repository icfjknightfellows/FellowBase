class TrackableMetricTwitterWorker

  include Sidekiq::Worker
  sidekiq_options backtrace: true


  def perform(item_id)
    asset = DigitalAsset.find_by(item_id: item_id)
    response = ImpactMonitorApi.get_tweets(item_id)

    if response["error"].present?
      puts ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
      puts asset.asset
      puts response
      puts ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
    end


    unless response["error"].present?

      tweets = response["tweets"]

      sentiments = tweets.group_by{|x| x["sentiment"]}
      sentiments.map{|k,v| sentiments[k] = v.count}
      # sentiments.delete("unknown")

      #### Twitter Sentiments
      sentiments.each do |k,v|
        TrackableMetric.create_or_update(response["item_id"], asset.digital_asset_id, "twitter", "sentiment_" + k, v)
      end

      #### Twitter retweets
      retweet_count = tweets.pluck("retweets").inject{|sum, n| sum.to_i + n.to_i}
      retweet_count = retweet_count || 0
      TrackableMetric.create_or_update(response["item_id"], asset.digital_asset_id, "twitter", "retweets", retweet_count)
    end
  end

end