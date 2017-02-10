class ReportsController < ApplicationController
  def index
    @report_data = Report.all.to_json
  end
end