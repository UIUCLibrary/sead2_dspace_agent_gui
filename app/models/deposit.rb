class Deposit < ActiveRecord::Base
  serialize :creator
  sead_api = SeadApi.new
  sead_api.sync_researchobjects

  include Sead2DspaceAgent
end
