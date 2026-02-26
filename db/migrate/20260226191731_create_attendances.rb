class CreateAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :attendances do |t|
      t.references :store, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.string :result
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
