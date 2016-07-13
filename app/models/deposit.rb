class Deposit < ActiveRecord::Base
  has_many :statuses, dependent: :destroy
  has_many :research_objects, dependent: :destroy

  serialize :creator
  serialize :abstract

  attr_reader :deposit_license_accepted

  def deposit_license_accepted=(string_value)
    @deposit_license_accepted = (string_value == '1')
  end

  def self.sync_from_api
    SeadApi.sync_deposits
  end

end
