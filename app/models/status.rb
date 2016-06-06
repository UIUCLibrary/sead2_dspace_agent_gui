class Status < ActiveRecord::Base
  belongs_to :deposit
  # t.datetime "date"
  # t.string   "reporter"
  # t.string   "stage"
  # t.text     "message"

  # attr_accessor :date

  def url
    deposit.ore_url.chomp('#aggregation').gsub('oremap', 'status')
  end

  def to_json
    {reporter: reporter, stage: stage, message: message}.to_json
  end

end
