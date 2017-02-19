class StaticPagesController < ApplicationController
  def index
    if current_user.present?
      redirect_to report_path
    else
      redirect_to new_user_session_path, alert: I18n.t('messages.sign_in')
    end
  end

  def set_selected_dimensions
    user_id = params[:user_id]
    selected_dimensions = params[:selected_dimensions]
    user = User.find_by(user_id: user_id)
    if user.present?
      user.update_column(:selected_dimensions, selected_dimensions)
      render json: { success: true }, status: 200
    else
      render json: { success: false, error: "User not found." }, status: 404
    end
  end
end
