class BooksController < ApplicationController
  before_action :set_book, only: [ :show ]

  def index
    @query = params[:q].to_s.strip
    @books = Book.includes(:author, :tags).order(:name)
    if @query.present?
      @books = @books.joins(:author)
                     .where("books.name ILIKE :q OR authors.name ILIKE :q", q: "%#{@query}%")
    end
  end

  def show
    @active_loan       = @book.loans.where(returned_at: nil).order(loaned_at: :desc).first
    @user_active_loan  = current_user ? @book.loans.where(user: current_user, returned_at: nil).first : nil
    @user_active_count = current_user ? current_user.loans.where(returned_at: nil).count : 0
  end

  private

  def set_book
    @book = Book.includes(:author, :tags).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, alert: "Book not found."
  end
end
