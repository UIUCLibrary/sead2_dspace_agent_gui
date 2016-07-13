class CreateAggregatedResources < ActiveRecord::Migration
  def change
    create_table :aggregated_resources do |t|
      t.string :uploaded_by
      t.string :is_version_of
      t.string :title
      t.string :size
      t.string :similar_to
      t.string :label
      t.string :identifier
      t.string :sha512

      t.timestamps null: false
    end
  end
end
