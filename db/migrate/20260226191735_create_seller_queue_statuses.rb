class CreateSellerQueueStatuses < ActiveRecord::Migration[8.1]
  def change
    create_table :seller_queue_statuses do |t|
      t.references :store, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.string :status
      t.integer :position

      t.timestamps
    end
  end
end
