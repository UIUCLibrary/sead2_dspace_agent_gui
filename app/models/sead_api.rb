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
      delete_leftover_deposits(api_deposits)
    end
  end

  def self.update_status(status)
    response = conn.post do |req|
      req.url status.url
      req.headers['Content-Type'] = 'application/json'
      req.body = status.to_json
    end
    status.date = DateTime.parse(response.headers['date'])
    status.save
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
        deposit.abstract = Array.wrap api_deposit_detail['Aggregation']['Abstract']
        deposit.created = DateTime.parse(api_deposit_detail['Aggregation']['Creation Date'])
        deposit.ore_url = api_deposit_detail['Aggregation']['@id']

        new_record = deposit.new_record?
        deposit.save

        sync_deposit_statuses(deposit, api_deposit_detail['Status'])
        sync_research_objects(deposit)

        send_receipt(deposit) if new_record
      end
    end

    def self.sync_research_objects(deposit)
      ore_response = conn.get "/sead-c3pr/api/researchobjects/#{deposit[:identifier]}/oremap#aggregation"

      ore_response = conn.get do |req|
        req.url "/c3pr/proxy/sead-c3pr/api/researchobjects/#{deposit[:identifier]}/oremap#aggregation"
        req.headers['Cookie'] = CGI::Cookie.new('JSESSIONID', COOKIE).to_s
      end if USE_PROXY

      if ore_response.body
        api_research_object = JSON.parse(ore_response.body)
        research_object = ResearchObject.find_or_initialize_by(deposit: deposit, identifier: deposit[:identifier])
        research_object.ore_url = api_research_object['describes']['@id']
        research_object.uploaded_by = api_research_object['describes']['Uploaded By']
        research_object.is_version_of = api_research_object['describes']['Is Version Of']
        research_object.title = api_research_object['describes']['Title']
        research_object.topic = Array.wrap api_research_object['describes']['Topic']
        research_object.similar_to = api_research_object['describes']['similarTo']
        research_object.creator = Array.wrap api_research_object['describes']['Creator']
        research_object.abstract = Array.wrap api_research_object['describes']['Abstract']
        research_object.publication_date = api_research_object['describes']['Publication Date']
        research_object.publishing_project = api_research_object['describes']['Publishing Project']
        research_object.save

        sync_aggregated_resources(research_object, api_research_object['describes']['aggregates'])
      end
    end

    def self.sync_aggregated_resources(research_object, api_aggregated_resources)
      api_aggregated_resources.each do |api_aggregated_resource|
        aggregated_resource = AggregatedResource.find_or_initialize_by(research_object: research_object, identifier: api_aggregated_resource['Identifier'])
        aggregated_resource.uploaded_by = api_aggregated_resource['Uploaded By']
        aggregated_resource.is_version_of = api_aggregated_resource['Is Version Of']
        aggregated_resource.title = api_aggregated_resource['Title']
        aggregated_resource.size = api_aggregated_resource['Size']
        aggregated_resource.mime_type = api_aggregated_resource['Mimetype']
        aggregated_resource.similar_to = api_aggregated_resource['similarTo']
        aggregated_resource.label = api_aggregated_resource['Label']
        aggregated_resource.sha512 = api_aggregated_resource['SHA512 Hash']
        aggregated_resource.save
        aggregated_resource
      end
    end

    def self.sync_deposit_statuses(deposit, api_statuses)
      api_statuses.each do |api_status|
        status = Status.find_or_initialize_by(deposit: deposit, date: DateTime.parse(api_status['date']))
        status.reporter = api_status['reporter']
        status.stage = api_status['stage']
        status.message = api_status['message']
        status.save
        status
      end
    end

    def self.send_receipt(deposit)
      status = deposit.statuses.create(reporter: 'IDEALS', stage: 'Pending', message: 'Your deposit was synced with IDEALS MatchMaker Agent, and it is awaiting approval for submission into the repository.')
      SeadApi.update_status(status)
    end

    def self.delete_leftover_deposits(api_deposits)
      ids = []
      api_deposits.each do |api_deposit|
        ids << api_deposit['Aggregation']['Identifier']
      end
      out_of_sync_deposits = Deposit.where.not(identifier: ids)
      out_of_sync_deposits.destroy_all
    end


end
