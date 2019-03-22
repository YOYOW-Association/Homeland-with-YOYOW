# frozen_string_literal: true

class AssetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @assets = current_user.pending_assets.order("id asc")
    @logs   = current_user.asset_change_logs.order("id desc")
  end
end
