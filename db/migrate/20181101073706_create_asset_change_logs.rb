class CreateAssetChangeLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :asset_change_logs do |t|
      t.integer :user_id,     null: false
      t.string  :asset_name,  null: false
      t.decimal :amount, precision: 15, scale: 5, null: false
      t.string :operator  # 操作人
      t.string :op_type, null: false  # 变更类型
      t.string :status    # 状态，备用

      t.timestamps
    end

    add_index :asset_change_logs, :user_id
    add_index :asset_change_logs, [:user_id, :asset_name]
    add_index :asset_change_logs, :op_type

  end
end
