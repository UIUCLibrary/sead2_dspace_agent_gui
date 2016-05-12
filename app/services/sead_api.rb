# require 'config/config.yml'
# see: https://www.getdonedone.com/building-rails-dashboard-app-donedone-api/
class SeadApi

  def initialize
    services = YAML.load_file "#{File.join(Rails.root, 'config', 'services.yml')}"
    @c3pr_base_url = services['sead']['c3pr_base_url']
    @repository_id = services['sead']['repository_id']
    @ro_list_url = "#{@c3pr_base_url}/repositories/#{@repository_id}/researchobjects"
    @ro_base_url = "#{@c3pr_base_url}/researchobjects"
  end


  def sync_researchobjects
    response = RestClient.get @ro_list_url
    if response.body
      ro_list = JSON.parse(response.body)
      ro_list.select { |ro|
        @ro_status = ro['Status'][0]['stage']
        # @ro_status_final = ro['Status'][2]['stage']
        ro['Status'].length == 1 and @ro_status == 'Receipt Acknowledged'
      }.map { |ro|
        agg_id = CGI.escape(ro['Aggregation']['Identifier'])
        RestClient.get("https://seadva-test.d2i.indiana.edu/sead-c3pr/api/researchobjects/#{agg_id}")
      }.map { |ro|
        attrs    = JSON.parse ro
        current_title = attrs['Aggregation']['Title']

        if Deposit.where(:title => current_title).blank?
          Deposit.new do |d|
            d.title         = attrs['Aggregation']['Title']
            d.creator       = Array.wrap attrs['Aggregation']['Creator']
            d.abstract      = attrs['Aggregation']['Abstract']
            d.creation_date = attrs['Aggregation']['Creation Date']
            d.status        = @ro_status
            d.save
          end
        end
      }
    end

  end

  def update_status(stage, message, research_object)
    RestClient.post(research_object.status_url,
                    {reporter: @repository_id, stage: stage, message: message}.to_json,
                    {content_type: :json, accept: :json}) if Sead2DspaceAgent::CONFIG['env'] == 'production'
  end
end
