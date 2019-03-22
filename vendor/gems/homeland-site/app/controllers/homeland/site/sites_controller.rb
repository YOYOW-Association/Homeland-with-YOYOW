module Homeland::Site
  class SitesController < Homeland::Site::ApplicationController
    def index
      @site_nodes = SiteNode.all.order(sort: :desc)
    end

    def new
      authorize! :create, ::Site
      @site = ::Site.new
    end

    def create
      authorize! :create, ::Site
      @site = ::Site.new(site_params)
      @site.user_id = current_user.id
      if @site.save
        redirect_to(sites_path, notice: '提交成功。谢谢。')
      else
        render action: 'new'
      end
    end

    private

    def site_params
      params.require(:site).permit(:name, :desc, :url, :favorite, :site_node_id)
    end
  end
end
