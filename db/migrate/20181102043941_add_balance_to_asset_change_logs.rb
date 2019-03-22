class AddBalanceToAssetChangeLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :asset_change_logs, :balance, :decimal, precision: 15, scale: 5
  end
end
