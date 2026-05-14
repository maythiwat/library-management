class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :name
      t.datetime :deleted_at
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
    add_index :books, :deleted_at
  end
end
