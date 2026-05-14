class CreateLoans < ActiveRecord::Migration[8.1]
  def change
    create_table :loans do |t|
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :loaned_at
      t.datetime :due_at
      t.datetime :returned_at

      t.timestamps
    end
  end
end
