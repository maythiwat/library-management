class Dashboard::UsersController < Dashboard::BaseController
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    authorize! :read, User
    @users = User.includes(:member_profile, :roles).order(:email)
  end

  def show
    authorize! :read, User
    @loans = @user.loans.includes(:book).order(created_at: :desc)
  end

  def update
    authorize! :manage, User
    new_roles = Array(params[:roles] || []) & %w[admin librarian]
    %w[admin librarian].each do |role|
      if new_roles.include?(role)
        @user.add_role(role) unless @user.has_role?(role)
      else
        @user.remove_role(role) if @user.has_role?(role)
      end
    end
    redirect_to dashboard_user_path(@user), notice: "Roles updated."
  end

  def destroy
    authorize! :manage, User
    @user.destroy
    redirect_to dashboard_users_path, notice: "User deleted."
  end

  private

  def set_user
    @user = User.includes(:member_profile, :roles).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_users_path, alert: "User not found."
  end
end
