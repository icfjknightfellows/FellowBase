class StaticPagesController < ApplicationController
  def index
    if current_user.present?
      redirect_to report_path
    else
      redirect_to new_user_session_path, alert: I18n.t('messages.sign_in')
    end
  end
end
