require 'test_helper'

class SeadApiTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    VCR.insert_cassette 'sync_deposits'
  end

  def teardown
    VCR.eject_cassette
  end

  test 'it_syncs_publications' do
    SeadApi.sync_deposits
    assert Deposit.count == 1
    deposit = Deposit.first
    assert deposit.identifier == 'urn:uuid:574dbb4de4b0b3e857298c3e'
    statuses = deposit.statuses
    assert statuses.length == 1
    status = statuses.first
    assert status.date == '2016-05-31 12:27:14'
  end

end
