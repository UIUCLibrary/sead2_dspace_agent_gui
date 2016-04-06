class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.string :email
      t.string :title
      t.string :author
      t.date :creation_date
      t.string :project_url
      t.string :status
      t.string :state

      t.timestamps null: false
    end
  end
end
