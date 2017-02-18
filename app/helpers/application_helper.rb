module ApplicationHelper

  def indicator(error, tracked)
    if error.present? and !tracked
      return "<div class='digital-asset-indicators errored'></div>"
    elsif error.present?
      return "<div class='digital-asset-indicators no-data'></div>"
    elsif error.blank? and tracked
      return "<div class='digital-asset-indicators successful'></div>"
    end
  end
end
