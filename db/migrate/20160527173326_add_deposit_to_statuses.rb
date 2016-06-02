class AddDepositToStatuses < ActiveRecord::Migration
  def change
    add_reference :statuses, :deposit, index: true, foreign_key: true
  end
end
