class CreatePromos < ActiveRecord::Migration[8.0]
  def change
    create_table :promos do |t|
      t.string :user_id, null: false, limit: 36
      t.string :store_id, null: false, limit: 36
      t.string  :title, null: false, limit: 200
      t.text    :description, limit: 1000
      t.decimal :original_price, precision: 10, scale: 2, null: false
      t.decimal :promo_price, precision: 10, scale: 2, null: false
      t.integer :promo_type, null: false # enum: physical/online
      t.string  :link
      t.string  :full_address
      t.float   :latitude
      t.float   :longitude
      t.datetime :expires_at
      t.boolean  :is_verified, null: false, default: false
      t.string :product_brand, null: false
      t.string :product_size,  null: false
      t.string :image_url
      t.timestamps
    end

    add_index :promos, :user_id
    add_index :promos, :store_id
    add_foreign_key :promos, :users, column: :user_id, primary_key: :id
    add_foreign_key :promos, :stores, column: :store_id, primary_key: :id
    add_index :promos, :promo_type
    add_index :promos, :expires_at
    add_index :promos, :product_brand
    add_index :promos, :product_size
    add_index :promos, :created_at

    # garante “link cadastrado uma vez” (para online) na prática:
    add_index :promos, :link, unique: true, where: "link IS NOT NULL"
  end
end
