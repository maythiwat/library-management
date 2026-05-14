class CreateMemberProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :member_profiles do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
