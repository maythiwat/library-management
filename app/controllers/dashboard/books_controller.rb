class Dashboard::BooksController < Dashboard::BaseController
  before_action :set_book, only: [ :edit, :update, :destroy ]

  def index
    @books = Book.includes(:author, :tags).order(:name)
  end

  def new
    authorize! :create, Book
    @book    = Book.new
    @authors = Author.order(:name)
    @tags    = Tag.order(:name)
  end

  def create
    authorize! :create, Book
    @book = Book.new(book_params)
    if @book.save
      redirect_to dashboard_books_path, notice: "Book created."
    else
      @authors = Author.order(:name)
      @tags    = Tag.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! :update, @book
    @authors = Author.order(:name)
    @tags    = Tag.order(:name)
  end

  def update
    authorize! :update, @book
    if @book.update(book_params)
      redirect_to dashboard_books_path, notice: "Book updated."
    else
      @authors = Author.order(:name)
      @tags    = Tag.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @book
    @book.destroy
    redirect_to dashboard_books_path, notice: "Book deleted."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_books_path, alert: "Book not found."
  end

  def book_params
    params.require(:book).permit(:name, :author_id, tag_ids: [])
  end
end
