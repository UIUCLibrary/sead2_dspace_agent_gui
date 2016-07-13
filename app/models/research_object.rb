class ResearchObject < ActiveRecord::Base
  belongs_to :deposit
  has_many :aggregated_resources, dependent: :destroy

  serialize :creator
  serialize :abstract
  serialize :topic
end
