class Dashboard::TagsController < Dashboard::BaseController
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.includes(:books).order(:name)
  end

  def new
    authorize! :create, Tag
    @tag = Tag.new
  end

  def create
    authorize! :create, Tag
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to dashboard_tags_path, notice: "Tag created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! :update, @tag
  end

  def update
    authorize! :update, @tag
    if @tag.update(tag_params)
      redirect_to dashboard_tags_path, notice: "Tag updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @tag
    @tag.destroy
    redirect_to dashboard_tags_path, notice: "Tag deleted."
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_tags_path, alert: "Tag not found."
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
