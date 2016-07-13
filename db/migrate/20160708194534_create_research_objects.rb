class CreateResearchObjects < ActiveRecord::Migration
  def change
    create_table :research_objects do |t|
      t.string :identifier
      t.string :ore_url
      t.string :uploaded_by
      t.string :is_version_of
      t.string :title
      t.string :topic
      t.string :similar_to
      t.string :creator
      t.text :abstract
      t.date :publication_date
      t.string :publishing_project
    end
  end
end
