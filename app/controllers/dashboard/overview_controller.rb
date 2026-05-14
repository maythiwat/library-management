class Dashboard::OverviewController < Dashboard::BaseController
  def index
    @total_books    = Book.count
    @total_authors  = Author.count
    @total_tags     = Tag.count
    @total_users    = User.count
    @active_loans   = Loan.where(returned_at: nil).count
    @overdue_loans  = Loan.where(returned_at: nil).where("due_at < ?", Time.current).count
    @recent_loans   = Loan.includes(:book, user: :member_profile).order(created_at: :desc).limit(6)
  end
end
