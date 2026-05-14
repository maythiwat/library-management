class LoansController < ApplicationController
  before_action :authenticate_user!

  def index
    @active_loans = current_user.loans
                                .includes(:book)
                                .where(returned_at: nil)
                                .order(due_at: :asc)
    @past_loans   = current_user.loans
                                .includes(:book)
                                .where.not(returned_at: nil)
                                .order(returned_at: :desc)
  end

  def create
    @book = Book.find(params[:book_id])

    unless @book.available?
      redirect_to book_path(@book), alert: "This book is currently on loan."
      return
    end

    if current_user.loans.where(returned_at: nil).count >= 3
      redirect_to book_path(@book), alert: "You can only have 3 active loans at a time."
      return
    end

    if @book.loans.where(user: current_user, returned_at: nil).exists?
      redirect_to book_path(@book), alert: "You already have this book on loan."
      return
    end

    loan = Loan.new(
      book: @book,
      user: current_user,
      loaned_at: Date.today,
      due_at: Date.today + 7.days
    )

    if loan.save
      redirect_to book_path(@book), notice: "Loaned successfully! Please return by #{loan.due_at.strftime('%d %B %Y')}."
    else
      redirect_to book_path(@book), alert: "Could not process loan. Please try again."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, alert: "Book not found."
  end
end
