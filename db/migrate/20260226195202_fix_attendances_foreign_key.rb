class FixAttendancesForeignKey < ActiveRecord::Migration[8.1]
  def change
    # Remove the old foreign key constraint that references sellers table
    remove_foreign_key :attendances, column: :seller_id, if_exists: true

    # Add the correct foreign key constraint that references users table
    add_foreign_key :attendances, :users, column: :seller_id
  end
end
