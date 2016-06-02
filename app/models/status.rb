class Status < ActiveRecord::Base
  belongs_to :deposit
  # t.datetime "date"
  # t.string   "reporter"
  # t.string   "stage"
  # t.text     "message"
end
