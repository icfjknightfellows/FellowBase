class ReportsController < ApplicationController
  before_action :authenticate_user!
  def index
    @report_data = Report.all.to_json
  end
end