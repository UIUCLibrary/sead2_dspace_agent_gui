class AddPropertiesToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :publication_callback, :string
    add_column :deposits, :license, :text
    add_column :deposits, :rights_holder, :string
    add_column :deposits, :created, :date
    add_column :deposits, :identifier, :string
    add_column :deposits, :ore_url, :string
  end
end
