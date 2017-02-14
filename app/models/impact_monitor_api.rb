class ImpactMonitorApi
  class << self

    # Channel
    def add_monitored_item(item)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "add_item",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            uniqueid: ENV["CHANNEL_UNIQUEID"],
            item: item
          }
        }
      )
      return JSON.parse(response)
    end

    def list_channel_items
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "list_monitored_items",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            uniqueid: ENV["CHANNEL_UNIQUEID"]
          }
        }
      )
      return JSON.parse(response)
    end

    # Item
    def update_item(item_id, item_string)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "update",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item: item_string,
            item_id: item_id
          }
        }
      )
      return JSON.parse(response)
    end

    def get_overview(item_id)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "overview",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item_id: item_id
          }
        }
      )
      return JSON.parse(response)
    end

    def get_tweets(item_id)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "list_tweets",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item_id: item_id
          }
        }
      )
      return JSON.parse(response)
    end

    def get_social_shares(item_id)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "social_shares",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item_id: item_id
          }
        }
      )
      return JSON.parse(response)
    end

    def delete_item(item_id)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "delete_item",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            uniqueid: ENV["CHANNEL_UNIQUEID"],
            monitored_item_id: item_id
          }
        }
      )
      return JSON.parse(response)
    end

  end
end