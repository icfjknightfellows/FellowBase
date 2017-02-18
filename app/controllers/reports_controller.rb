class ReportsController < ApplicationController
  before_action :authenticate_user!
  def index
    @report_data = Report.all.to_json
  end

  def digital_assets
    @links_successful = DigitalAsset.successful
    @links_with_no_data = DigitalAsset.with_no_data.where.not(tracked: false)
    @links_errored = DigitalAsset.errored
  end

end