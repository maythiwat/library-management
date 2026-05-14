class Dashboard::AuthorsController < Dashboard::BaseController
  before_action :set_author, only: [:edit, :update, :destroy]

  def index
    @authors = Author.includes(:books).order(:name)
  end

  def new
    authorize! :create, Author
    @author = Author.new
  end

  def create
    authorize! :create, Author
    @author = Author.new(author_params)
    if @author.save
      redirect_to dashboard_authors_path, notice: "Author created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! :update, @author
  end

  def update
    authorize! :update, @author
    if @author.update(author_params)
      redirect_to dashboard_authors_path, notice: "Author updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @author
    @author.destroy
    redirect_to dashboard_authors_path, notice: "Author deleted."
  end

  private

  def set_author
    @author = Author.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_authors_path, alert: "Author not found."
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
