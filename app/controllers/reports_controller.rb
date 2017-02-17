class ReportsController < ApplicationController
  before_action :authenticate_user!
  def index
    @report_data = Report.all.to_json
  end

  def digital_assets
    @links_with_data = DigitalAsset.with_data
    @links_with_no_data = DigitalAsset.with_no_data
  end

end