class StaticPagesController < ApplicationController
  def index
    if current_user.present?
      redirect_to user_report_path
    else
      redirect_to new_user_session_path
    end
  end
end
