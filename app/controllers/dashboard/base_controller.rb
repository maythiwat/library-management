class Dashboard::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_dashboard_access!
  layout "dashboard"

  private

  def require_dashboard_access!
    unless current_user.has_role?(:admin) || current_user.has_role?(:librarian)
      redirect_to root_path, alert: "You are not authorized to access the dashboard."
    end
  end
end
