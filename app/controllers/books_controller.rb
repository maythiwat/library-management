class BooksController < ApplicationController
  before_action :set_book, only: [ :show ]

  def index
    @books = Book.order(:name)
  end

  def show
    render json: @book, status: :ok, include: [ :author, :tags ]
  end

  private
  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Book not found" }, status: :not_found
  end
end
