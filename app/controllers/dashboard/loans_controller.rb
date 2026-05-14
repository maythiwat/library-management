class Dashboard::LoansController < Dashboard::BaseController
  def index
    @loans = Loan.includes(:book, user: :member_profile).order(created_at: :desc)
  end

  def new
    authorize! :create, Loan
    @loan  = Loan.new(loaned_at: Date.today, due_at: Date.today + 14.days)
    @books = Book.includes(:loans).order(:name).select(&:available?)
    @users = User.includes(:member_profile).order(:email)
  end

  def create
    authorize! :create, Loan
    @loan = Loan.new(loan_params)
    if @loan.save
      redirect_to dashboard_loans_path, notice: "Loan recorded."
    else
      @books = Book.includes(:loans).order(:name).select(&:available?)
      @users = User.includes(:member_profile).order(:email)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, Loan
    @loan = Loan.find(params[:id])
    @loan.destroy
    redirect_to dashboard_loans_path, notice: "Loan deleted."
  end

  def return_book
    authorize! :update, Loan
    @loan = Loan.find(params[:id])
    @loan.update!(returned_at: Time.current)
    redirect_to dashboard_loans_path, notice: "Book marked as returned."
  end

  private

  def loan_params
    params.require(:loan).permit(:book_id, :user_id, :loaned_at, :due_at)
  end
end
