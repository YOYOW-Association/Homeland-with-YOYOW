class AddUuidToAssetChangeLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :asset_change_logs, :uuid, :string
  end
end
