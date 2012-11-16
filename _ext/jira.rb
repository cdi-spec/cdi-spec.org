require 'uri'

module Awestruct::Extensions::Jira
  DEFAULT_BASE_URL = 'https://issues.jboss.org'

  class Project
    def initialize(pipeline, *args)
      pipeline.extension ReleaseNotes.new *args
      pipeline.extension ComponentLeads.new *args
      pipeline.extension RoadMap.new *args
    end
  end

  # TODO: These all need to be pulled out and create modules or some sort of base
  class ReleaseNotes
    PROJECT_PATH_TEMPLATE = '/rest/api/latest/project/%s'
    RELEASE_NOTES_PATH_TEMPLATE = '/secure/ReleaseNote.jspa?projectId=%s&version=%s&_sscc=t'
    DURATION_1_DAY = 60 * 60 * 24

    # Expecting project_key as key:id (e.g., ARQ:12310885) because the JIRA REST API won't give up the project id
    def initialize(project_key, prefix_version = nil, base_url = DEFAULT_BASE_URL)
      (@project_key, @project_id) = project_key.split(':')
      @prefix_version = prefix_version
      @base_url = base_url
    end

    # TODO datacache me
    def execute(site)
      site.release_notes ||= {}
      # just in case we need other data, we'll just grab the versions from the project resource
      url = @base_url + (PROJECT_PATH_TEMPLATE % @project_key)
      project_data = RestClient.get url, :accept => 'application/json',
          :cache_key => "jira/project-#{@project_key}.json", :cache_expiry_age => DURATION_1_DAY
      project_data['versions'].each do |v|
        next if !v['released']
        release_key = v['name']
        release_key = "#{@prefix_version}_#{release_key}" unless @prefix_version.nil?

        url = @base_url + RELEASE_NOTES_PATH_TEMPLATE % [@project_id, v['id']]
        html = RestClient.get url, :cache_key => "jira/release-notes-#{@project_key}-#{v['id']}.html"
        doc = Nokogiri::HTML(html)
        release_notes = OpenStruct.new({
          :id => v['id'],
          :comment => v['description'],
          :key => release_key,
          :html_url => url,
          :resolved_issues => {}
        })
        doc.search('#editcopy > ul li').each do |e|
          type = e.parent.previous_element.inner_text.strip
          release_notes.resolved_issues[type] = [] if !release_notes.resolved_issues.has_key? type
          release_notes.resolved_issues[type] << e.inner_html
        end

        site.release_notes[release_key] = release_notes
      end
    end 
  end

  class RoadMap
    # TODO: Pull all this info from JIRA and put into the site struct
    # Get all the issues from the cached https://issues.jboss.org/rest/api/latest/project/CDI
    # Total issue count per version can be found by https://issues.jboss.org/rest/api/latest/version/%d/relatedIssueCount
    # Getting the issues (and labels) search?'+ URI.encode_www_form('jql' => "fixVersion=#{v['id']}", 'fields' => "id,key,summary,status,priority,labels", 'maxResults' => relatedIssueCounts['issuesFixedCount'])
    # Because there's no way of getting an aggregate of labels, each result from the search will need to have its labels added 
    #
    # Example yaml
    # ---
    #  - '1.0':
    #      id: '12315196'
    #      releaseDate: '2009-12-10'
    #      labels:
    #        - label 1 
    #        - label 2 
    #        - label 3 
    #  - 1.1 (Proposed):
    #      id: '12315197'
    #      releaseDate: 
    #      labels:
    #  - 1.1.EDR:
    #      id: '12315956'
    #      releaseDate: '2011-10-06'
    #      labels:
    #  - 1.1.PRD:
    #      id: '12318464'
    #      releaseDate: '2012-10-26'
    #      labels:
    #  - 1.1.PFD:
    #      id: '12319989'
    #      releaseDate: 
    #      labels:
    #  - TBD:
    #      id: '12315955'
    #      releaseDate: 
    #      labels:

    
    REST_PATH = '/rest/api/latest/'
    PROJECT_PATH_TEMPLATE = REST_PATH + 'project/%s'
    VERSION_RELATED_ISSUES_COUNT_PATH_TEMPLATE = REST_PATH + 'version/%s/relatedIssueCounts'
    DURATION_1_DAY = 60 * 60 * 24

    # Expecting project_key as key:id (e.g., ARQ:12310885) because the JIRA REST API won't give up the project id
    def initialize(project_key, prefix_version = nil, base_url = DEFAULT_BASE_URL)
      (@project_key, @project_id) = project_key.split(':')
      @prefix_version = prefix_version
      @base_url = base_url
    end

    # TODO datacache me
    def execute(site)
      site.roadmap ||= {}
      # just in case we need other data, we'll just grab the versions from the project resource
      url = @base_url + (PROJECT_PATH_TEMPLATE % @project_key)
      project_data = RestClient.get url, :accept => 'application/json',
          :cache_key => "jira/project-#{@project_key}.json", :cache_expiry_age => DURATION_1_DAY
      project_data['versions'].each do |v|
        next if v['released']

        url = @base_url + (VERSION_RELATED_ISSUES_COUNT_PATH_TEMPLATE % v['id'])
        relatedIssueCounts = RestClient.get url, :accept => 'application/json', :cache_key => "jira/version-#{@project_key}-#{v['id']}-relatedIssueCounts.json", :cache_expiry_age => DURATION_1_DAY
          
        relatedIssues = RestClient.get @base_url + REST_PATH + 'search?'+ URI.encode_www_form('jql' => "fixVersion=#{v['id']}", 'fields' => "id,key,summary,status,priority,description", 'maxResults' => relatedIssueCounts['issuesFixedCount']), :accept => 'application/json', :cache_key => "jira/version-#{@project_key}-#{v['id']}-relatedIssues.json", :cache_expiry_age => DURATION_1_DAY
        site.roadmap[v['id']] = {"name" => v['name'], "issues" => relatedIssues['issues']}
      end
    end 
  end

  class ComponentLeads
    COMPONENTS_PATH_TEMPLATE = '/rest/api/latest/project/%s/components'
    def initialize(project_key, base_url = DEFAULT_BASE_URL)
      (@project_key, @project_id) = project_key.split(':')
      @base_url = base_url
    end

    def execute(site)
      site.component_leads ||= {}
      url = @base_url + (COMPONENTS_PATH_TEMPLATE % @project_key)
      components = RestClient.get url, :accept => 'application/json',
          :cache_key => "jira/components-#{@project_key}.json"
      components.each do |c|
        component_data = RestClient.get c['self'], :accept => 'application/json',
            :cache_key => "jira/component-#{@project_key}-#{c['id']}.json"
        if component_data.has_key? 'lead' and component_data['description'] =~ / :: ([^ ]+)$/
          site.component_leads[$1] = OpenStruct.new({
            :name => component_data['lead']['displayName'],
            :jboss_username => component_data['lead']['name']
          })
        end
      end
    end
  end
end
