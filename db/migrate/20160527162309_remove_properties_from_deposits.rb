class RemovePropertiesFromDeposits < ActiveRecord::Migration
  def change
    remove_column :deposits, :email, :string
    remove_column :deposits, :creation_date, :date
    remove_column :deposits, :project_url, :string
    remove_column :deposits, :status, :string
  end
end
