class AddThumbnailUrlToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :thumbnail_url, :string
  end
end
