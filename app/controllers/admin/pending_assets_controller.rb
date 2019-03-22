# frozen_string_literal: true

module Admin
  class PendingAssetsController < Admin::ApplicationController
    before_action :find_user, only: [:index, :create, :destroy]

    def index
      if @user
        @assets = @user.pending_assets.all
        @logs   = @user.asset_change_logs.order('id desc').all
      else
        @assets = PendingAsset.all
        @logs   = AssetChangeLog.order('id desc').all
      end
    end

    def create
      uuid          = params[:t]
      delta         = pending_asset_param.delete(:amount)&.to_f
      pending_asset = @user.pending_assets
                          .find_by_asset_name(pending_asset_param[:asset_name])

      unless pending_asset
        pending_asset = @user.pending_assets.new(pending_asset_param)
      end

      begin
        PendingAsset.log_and_save(pending_asset, delta, current_user.login, uuid)
        redirect_to(admin_pending_assets_path(user_id: @user.id), notice: "Asset was successfully created.")
      rescue
        redirect_to(admin_pending_assets_path(user_id: @user.id), notice: "Asset was failed to create.")
      end
    end

    def pending_assets
      @assets = PendingAsset.include(Users).all
      @logs   = AssetChangeLog.all
      render :index
    end

    private

      def find_user
        @user   = User.find(params[:user_id]) rescue nil
      end

      def pending_asset_param
        params.require(:pending_asset).permit(:asset_name, :amount)
      end
  end
end
