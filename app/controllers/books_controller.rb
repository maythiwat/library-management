class BooksController < ApplicationController
  before_action :set_book, only: [ :show ]

  def index
    @books = Book.includes(:author, :tags).order(:name)
  end

  def show
    @active_loan = @book.loans.where(returned_at: nil).order(loaned_at: :desc).first
    @user_active_loan = current_user ? @book.loans.where(user: current_user, returned_at: nil).first : nil
  end

  private

  def set_book
    @book = Book.includes(:author, :tags).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, alert: "Book not found."
  end
end
