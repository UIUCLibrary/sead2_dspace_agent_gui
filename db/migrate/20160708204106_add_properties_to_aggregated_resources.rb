class AddPropertiesToAggregatedResources < ActiveRecord::Migration
  def change
    add_column :aggregated_resources, :mime_type, :string
  end
end
