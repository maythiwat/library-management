class BooksController < ApplicationController
  def index
    @books = Book.order(:name)
  end
end
