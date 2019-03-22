class AddCategoryAndCoverImageToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :post_category_id, :integer
    add_column :posts, :cover_image, :string
  end
end