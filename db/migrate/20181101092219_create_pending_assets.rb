class CreatePendingAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :pending_assets do |t|
      t.integer :user_id,   null: false
      t.string :asset_name, null: false

      # precision - Defines the precision for the decimal fields, representing the total number of digits in the number.
      # scale - Defines the scale for the decimal fields, representing the number of digits after the decimal point.
      t.decimal :amount, precision: 15, scale: 5

      t.timestamps
    end

    add_index :pending_assets, :user_id
    add_index :pending_assets, [:user_id, :asset_name], unique: true
  end
end
