class Dashboard::BooksController < Dashboard::BaseController
  before_action :set_book,         only: [ :show, :edit, :update, :destroy ]
  before_action :set_deleted_book, only: [ :restore ]

  def index
    @books = Book.includes(:author, :tags).order(:name)
  end

  def show
    redirect_to edit_dashboard_book_path(@book)
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
    @authors  = Author.order(:name)
    @tags     = Tag.order(:name)
    @versions = @book.versions.order(created_at: :desc)
    user_ids  = @versions.map(&:whodunnit).compact.uniq
    @version_users = User.where(id: user_ids).index_by { |u| u.id.to_s }
  end

  def update
    authorize! :update, @book
    if @book.update(book_params)
      redirect_to edit_dashboard_book_path(@book), notice: "Book updated."
    else
      @authors  = Author.order(:name)
      @tags     = Tag.order(:name)
      @versions = @book.versions.order(created_at: :desc)
      user_ids  = @versions.map(&:whodunnit).compact.uniq
      @version_users = User.where(id: user_ids).index_by { |u| u.id.to_s }
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @book
    @book.destroy
    redirect_to dashboard_books_path, notice: "\"#{@book.name}\" moved to trash."
  end

  def trash
    authorize! :manage, Book
    @deleted_books = Book.only_deleted.includes(:author).order(deleted_at: :desc)
  end

  def restore
    authorize! :manage, Book
    @book.restore
    redirect_to dashboard_books_path, notice: "\"#{@book.name}\" has been restored."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_books_path, alert: "Book not found."
  end

  def set_deleted_book
    @book = Book.only_deleted.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to trash_dashboard_books_path, alert: "Book not found in trash."
  end

  def book_params
    params.require(:book).permit(:name, :author_id, :thumbnail_url, tag_ids: [])
  end
end
