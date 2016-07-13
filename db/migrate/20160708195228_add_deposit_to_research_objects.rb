class AddDepositToResearchObjects < ActiveRecord::Migration
  def change
    add_reference :research_objects, :deposit, index: true, foreign_key: true
  end
end
