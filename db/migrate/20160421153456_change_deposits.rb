class ChangeDeposits < ActiveRecord::Migration
  def change
    change_table :deposits do |t|
      t.rename :author, :creator
      t.text :abstract
    end
  end
end
