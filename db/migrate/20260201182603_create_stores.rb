class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :is_online
      t.string :website_url
      t.integer :promos_count

      t.timestamps
    end

    add_index :stores, :name
  end
end
