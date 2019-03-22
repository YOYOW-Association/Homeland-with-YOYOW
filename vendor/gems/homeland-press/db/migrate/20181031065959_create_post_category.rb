class CreatePostCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :post_categories do |t|
      t.string :name
      t.integer :post_id
      
      t.timestamps
    end

    add_index :post_categories, :name, unique: true
  end
end
