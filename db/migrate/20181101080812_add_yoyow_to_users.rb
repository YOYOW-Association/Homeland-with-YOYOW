class AddYoyowToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :yoyow, :string
  end
end
