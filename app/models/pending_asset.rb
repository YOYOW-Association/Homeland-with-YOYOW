class PendingAsset < ApplicationRecord
  belongs_to :user

  validates :asset_name, presence: true, allow_blank: false

  def self.log_and_save(asset, delta, operator, uuid)
    ActiveRecord::Base.transaction do
      asset.amount += delta.to_f
      asset.save!

      AssetChangeLog.create!(
          user_id:    asset.user_id,
          asset_name: asset.asset_name,
          amount:     delta,
          op_type:    AssetChangeLog.op_types['manual'],
          operator:   operator,
          uuid:       uuid,
          balance:    asset.amount
      )
    rescue Exception => e
      p e.message
    end
  end
end