class ChangeDeposits < ActiveRecord::Migration
  def change
    change_table :deposits do |t|
      t.rename :author, :creator
    end
  end
end
