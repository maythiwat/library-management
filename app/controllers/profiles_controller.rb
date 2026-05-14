class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @profile      = current_user.member_profile || current_user.build_member_profile
    @active_loans = current_user.loans.where(returned_at: nil).includes(:book).order(due_at: :asc)
    @total_loans  = current_user.loans.count
  end

  def edit
    @profile = current_user.member_profile || current_user.build_member_profile
  end

  def update
    @profile      = current_user.member_profile || current_user.build_member_profile
    @profile.user = current_user

    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:member_profile).permit(:name)
  end
end
