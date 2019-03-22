# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    # @excellent_topics = Topic.excellent.recent.fields_for_list.limit(20).to_a
    #
    # pinned_posts    = Post.where(:pinned => true).order('rank desc').order('updated_at desc').limit(6).to_a
    # @card_posts     = pinned_posts.pop(3)
    # @carousel_posts = pinned_posts
    #
    # @category_id    = params[:category_id]
    # @posts  = Post.where('pinned <> true or pinned is null')
    # if @category_id
    #   @posts = @posts.where(:post_category_id => params[:category_id])
    # end
    # @posts = @posts.page(params[:page])#.per(2)
    #
    redirect_to '/posts'
  end

  def uploads
    return render_404 if Rails.env.production?

    # This is a temporary solution for help generate image thumb
    # that when you use :file upload_provider and you have no Nginx image_filter configurations.
    # DO NOT use this in production environment.
    format, version = params[:format].split("!")
    filename = [params[:path], format].join(".")
    pragma = request.headers["Pragma"] == "no-cache"
    thumb = Homeland::ImageThumb.new(filename, version, pragma: pragma)
    if thumb.exists?
      send_file thumb.outpath, type: "image/jpeg", disposition: "inline"
    else
      render plain: "File not found", status: 404
    end
  end

  def api
    redirect_to "/api-doc/"
  end

  def error_404
    render_404
  end

  def markdown
  end
end
