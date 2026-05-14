class LoansController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])

    unless @book.available?
      redirect_to book_path(@book), alert: "This book is currently on loan."
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
