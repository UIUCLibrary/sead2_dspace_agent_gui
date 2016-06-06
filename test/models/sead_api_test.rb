require 'test_helper'

class SeadApiTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    VCR.insert_cassette 'sync_deposits', record: :new_episodes
    SeadApi.sync_deposits
  end

  def teardown
    VCR.eject_cassette
  end

  test 'it_syncs_publications' do
    assert Deposit.count == 1
    deposit = Deposit.first
    assert deposit.identifier == 'urn:uuid:574dbb4de4b0b3e857298c3e'
    statuses = deposit.statuses
    status = statuses.first
    assert status.date == '2016-05-31 12:27:14'
  end

  test 'it_syncs_statuses' do
    deposit = Deposit.first
    status = deposit.statuses.first
    assert status.url == 'https://seadva-test.d2i.indiana.edu/sead-c3pr/api/researchobjects/urn:uuid:574dbb4de4b0b3e857298c3e/status'
  end

  test 'it_updates_statuses' do
    deposit = Deposit.first
    status = deposit.statuses.create(reporter: 'IDEALS', stage: 'Pending', message: 'Processing research object')
    SeadApi.update_status(status)
    assert status.date
  end

end
