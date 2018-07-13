class CreateSpreeCustomerSegments < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_customer_segments do |t|
      t.string :name
      t.text :filters
      t.integer :user_id
      t.timestamps

      t.index :user_id
    end
  end
end
