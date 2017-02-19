class ReportsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_search_query, except: [:index]

  def index
    @report_data = Report.all.to_json
    @selecte_dimensions = current_user.selected_dimensions
    @user_id = current_user.user_id
  end

  def all
    @links = DigitalAsset.order(custom_errors: :desc).page(params[:page]).per(20)
  end

  def successful
    @links = DigitalAsset.successful.page(params[:page]).per(20)
  end

  def errored
    @links = DigitalAsset.errored.order(custom_errors: :desc).page(params[:page]).per(20)
  end

  def with_no_data
    @links = DigitalAsset.with_no_data.order(custom_errors: :desc).where.not(tracked: false).page(params[:page]).per(20)
  end

  def search
    @links = @q.result.order(custom_errors: :desc).page(params[:page]).per(20)
  end

  private

    def set_search_query
      @q = DigitalAsset.ransack(params[:q])
    end

end