class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.datetime :date
      t.string :reporter
      t.string :stage
      t.text :message

      t.timestamps null: false
    end
  end
end
