class AddResearchObjectToAggregatedResources < ActiveRecord::Migration
  def change
    add_reference :aggregated_resources, :research_object, index: true, foreign_key: true
  end
end
