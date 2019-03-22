class AssetChangeLog < ApplicationRecord
  belongs_to :user

  validates_presence_of :op_type,   allow_blank: false
  validates_presence_of :operator,  allow_blank: false
  validates_presence_of :uuid,      allow_blank: false, uniqueness: true

  enum op_type: { manual: '手动登记', auto: '自动登记', deposit: '充值', withdraw: '提现' }

  def op_type_name
    AssetChangeLog.op_types[op_type]
  end
end
