require 'faraday'
# Helper class for interacting with the SEAD API
#
# see: https://www.getdonedone.com/building-rails-dashboard-app-donedone-api/
class SeadApi

  COOKIE = '2E8A05E24C163A72748B5C19E6E85857'
  USE_PROXY = false

  def self.conn
    connection = Faraday.new(url: 'https://seadva-test.d2i.indiana.edu')
    connection = Faraday.new(url: 'https://sead-test.ncsa.illinois.edu') if USE_PROXY
    connection
  end

  def self.sync_deposits
    response = conn.get '/sead-c3pr/api/repositories/ideals/researchobjects'

    # use the proxy
    response = conn.get do |req|
      req.url '/c3pr/proxy/sead-c3pr/api/repositories/ideals/researchobjects'
      req.headers['Cookie'] = CGI::Cookie.new('JSESSIONID', COOKIE).to_s
    end if USE_PROXY

    if response.body
      api_deposits = JSON.parse response.body
      api_deposits.each do |api_deposit|
        identifier = api_deposit['Aggregation']['Identifier']
        sync_deposit_detail(identifier)
      end
    end
  end

  private

    def self.sync_deposit_detail(identifier)
      deposit_response = conn.get "/sead-c3pr/api/researchobjects/#{identifier}"

      deposit_response = conn.get do |req|
        req.url "/c3pr/proxy/sead-c3pr/api/researchobjects/#{identifier}"
        req.headers['Cookie'] = CGI::Cookie.new('JSESSIONID', COOKIE).to_s
      end if USE_PROXY

      if deposit_response.body
        api_deposit_detail = JSON.parse(deposit_response.body)
        deposit = Deposit.find_or_initialize_by(identifier: api_deposit_detail['Aggregation']['Identifier'])
        deposit.publication_callback = api_deposit_detail['Publication Callback']
        deposit.license = api_deposit_detail['License']
        deposit.rights_holder = api_deposit_detail['Rights Holder']
        deposit.title = api_deposit_detail['Aggregation']['Title']
        deposit.creator = Array.wrap api_deposit_detail['Aggregation']['Creator']
        deposit.abstract = api_deposit_detail['Aggregation']['Abstract']
        deposit.created = DateTime.parse(api_deposit_detail['Aggregation']['Creation Date'])
        deposit.ore_url = api_deposit_detail['Aggregation']['@id']

        deposit.save

        sync_deposit_statuses(deposit, api_deposit_detail['Status'])
      end
    end

    def self.sync_deposit_statuses(deposit, statuses)
      statuses.each do |api_status|
        status = Status.find_or_initialize_by(deposit: deposit, date: DateTime.parse(api_status['date']))
        status.reporter = api_status['reporter']
        status.stage = api_status['stage']
        status.message = api_status['message']
        status.save
        status
      end
    end


end
