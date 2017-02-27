# == Schema Information
#
# Table name: digital_asset_report
#
#  event_id          :string
#  event_name        :text
#  impact_type_id    :text
#  media             :text
#  topic             :text
#  user_id           :string
#  fellow            :string
#  impact_type       :text
#  impact_type_genre :string
#  ref_partner_id    :string
#  partner_name      :string
#  project_id        :string
#  project_name      :string
#  digital_asset_id  :string
#  asset             :text
#  post_type         :string
#  genre             :string
#  metric_type       :string
#  value             :integer
#

class Report < ActiveRecord::Base
  self.table_name = "digital_asset_report"
  #GEMS
  #ATTRIBUTES
  #ASSOCIATIONS
  #VALIDATIONS
  #CALLBACKS
  #FUNCTIONS

  class << self
    def refresh
      Report.connection.execute("REFRESH MATERIALIZED VIEW digital_asset_report;")
    end
  end


end
