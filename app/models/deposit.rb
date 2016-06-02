class Deposit < ActiveRecord::Base
  has_many :statuses, dependent: :destroy
  serialize :creator

  def self.sync_from_api
    SeadApi.sync_deposits
  end

end
