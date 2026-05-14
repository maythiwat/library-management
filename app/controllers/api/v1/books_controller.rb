class Api::V1::BooksController < ApplicationController
  before_action :set_book, only: [ :show ]

  def index
    @books = Book.includes(:author, :tags).order(:name)
    render json: { books: @books }, status: :ok
  end

  def show
    @active_loan = @book.loans.where(returned_at: nil).order(loaned_at: :desc).first
    render json: { book: @book, active_loan: @active_loan }, status: :ok
  end

  private
  def set_book
    @book = Book.includes(:author, :tags).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Book not found." }, status: :not_found
  end
end
