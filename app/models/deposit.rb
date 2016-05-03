class Deposit < ActiveRecord::Base
  SeadApi.sync_researchobjects

  include Sead2DspaceAgent
end
