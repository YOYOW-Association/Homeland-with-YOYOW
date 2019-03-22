module Homeland::Press
  class PostsController < Homeland::Press::ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :update, :publish, :destroy]
    before_action :set_post, only: [:show, :edit, :update, :publish, :destroy]

    # GET /posts
    def index
      # @posts = Post.includes(:user).published.order('published_at desc, id desc').page(params[:page]).per(10)
      # @excellent_topics = Topic.excellent.recent.fields_for_list.limit(20).to_a # 精华
      @topics= Topic.fields_for_list.high_replies.without_ban.without_hide_nodes.limit(7) # 最多回复

      pinned_posts    = Post.where(:pinned => true).order('rank desc').order('created_at desc').limit(6).to_a
      @card_posts     = pinned_posts.pop(3)
      @carousel_posts = pinned_posts

      @category_id    = params[:category_id]
      @posts  = Post.where('pinned <> true or pinned is null')
      if @category_id
        @posts = @posts.where(:post_category_id => params[:category_id])
      end
      @posts = @posts.order('created_at desc').page(params[:page])#.per(2)
    end

    def upcoming
      @posts = Post.includes(:user).upcoming.order('id desc').page(params[:page]).per(10)
    end

    # GET /posts/1
    def show
      @post.hits.incr(1)
    end

    def preview
      out = Homeland::Markdown.call(params[:body])
      render plain: out
    end

    # GET /posts/new
    def new
      authorize! :create, Post
      @post = Post.new
    end

    # GET /posts/1/edit
    def edit
      authorize! :update, @post
    end

    # POST /posts
    def create
      authorize! :create, Post
      @post = Post.new(post_params)
      @post.user_id = current_user.id

      if @post.save
        redirect_to @post, notice: '文章提交成功，需要等待管理员审核。'
      else
        render :new
      end
    end

    # PATCH/PUT /posts/1
    def update
      authorize! :update, @post
      if @post.update(post_params)
        redirect_to @post, notice: '文章更新成功。'
      else
        render :edit
      end
    end

    def publish
      authorize! :publish, @post
      @post.published!
      redirect_to posts_path, notice: "文章审核成功。"
    end

    # DELETE /posts/1
    def destroy
      authorize! :destroy, @post
      @post.destroy
      redirect_to posts_url, notice: '文章删除成功。'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_post
        @post = Post.find_by_slug!(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def post_params
        params.require(:post)
              .permit(:title, :slug, :body, :summary, :post_category_id, :cover_image, :pinned, :rank)
      end
  end
end
