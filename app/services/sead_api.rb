# require 'config/config.yml'
class SeadApi

  def initialize
    @c3pr_base_url = [:sead][:c3pr_base_url]
    @repository_id = [:sead][:repository_id]
    @ro_list_url = "#{@c3pr_base_url}/repositories/#{@repository_id}/researchobjects"
    @ro_base_url = "#{@c3pr_base_url}/researchobjects"
  end


  def self.sync_researchobjects
    response = RestClient.get('https://seadva-test.d2i.indiana.edu/sead-c3pr/api/repositories/ideals/researchobjects')
    if response.body
      ro_list = JSON.parse(response.body)
      ro_list.select { |ro|
        @ro_status = ro['Status'][0]['stage']
        ro['Status'].length == 3 and @ro_status == 'Receipt Acknowledged'
      }.map { |ro|
        agg_id = CGI.escape(ro['Aggregation']['Identifier'])
        RestClient.get("https://seadva-test.d2i.indiana.edu/sead-c3pr/api/researchobjects/#{agg_id}")
      }.map { |ro|
        attrs    = JSON.parse ro
        current_title = attrs['Aggregation']['Title']

        if Deposit.where(:title => current_title).blank?
          Deposit.new do |d|
            d.title    = attrs['Aggregation']['Title']
            d.creator  = attrs['Aggregation']['Creator']
            d.abstract = attrs['Aggregation']['Abstract']
            d.creation_date = attrs['Aggregation']['Creation Date']
            d.save
          end
        end


        # d = Deposit.find_or_initialize_by(title: attrs['Aggregation']['Title'])
        # d.creator  = attrs['Aggregation']['Creator']
        # d.abstract = attrs['Aggregation']['Abstract']
        # d.creation_date     = attrs['Aggregation']['Creation Date']
        # d.save
      }
    end

  end
end
