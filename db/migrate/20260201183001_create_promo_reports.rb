class CreatePromoReports < ActiveRecord::Migration[8.0]
  def change
    create_table :promo_reports do |t|
      t.references :promo, null: false, foreign_key: true

      # como users.id é varchar(36), a FK precisa ser string(36)
      t.string :user_id, null: false, limit: 36

      t.string :reason, null: false
      t.timestamps
    end

    add_index :promo_reports, [:promo_id, :user_id], unique: true

    add_foreign_key :promo_reports, :users, column: :user_id, primary_key: :id
  end
end
