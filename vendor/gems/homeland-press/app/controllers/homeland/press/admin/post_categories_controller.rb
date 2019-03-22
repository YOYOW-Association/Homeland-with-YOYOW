module Homeland::Press::Admin
  class PostCategoriesController < ::Admin::ApplicationController
    layout '/layouts/admin'

    def index
      @post_categories = PostCategory.order("id asc").page(params[:page])
      @category = PostCategory.new
    end

    def create
      @category = PostCategory.new(category_params)

      if @category.save
        redirect_to admin_post_categories_path, notice: '添加成功'
      else
        render :new
      end
    end

    def destroy
      @category = PostCategory.find(params[:id])
      @category.destroy
      redirect_to admin_post_categories_path
    end

    private

      # Only allow a trusted parameter "white list" through.
      def category_params
        params.require(:post_category).permit(:name)
      end
  end
end
