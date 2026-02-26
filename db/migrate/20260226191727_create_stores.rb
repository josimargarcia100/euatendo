class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :cnpj
      t.string :phone
      t.string :timezone

      t.timestamps
    end
  end
end
