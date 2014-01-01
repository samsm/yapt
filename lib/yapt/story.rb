module Yapt
  class Story
    def self.find(options = ["limit=5"])
      return find_one(options) if options.kind_of?(String)
      params = Filter.parse(options)
      results = Request.new("stories", params, :get).result
      results.collect {|r| new(r) }
    end

    def self.find_one(id)
      case id
      when /\A\d+\Z/  then find_by_id(id)
      when 'tback'    then top_of_backlog
      when 'tbacklog' then top_of_backlog
      when 'tice'     then top_of_icebox
      when 'ticebox'  then top_of_icebox

      when 'bback'    then bottom_of_backlog
      when 'bbacklog' then bottom_of_backlog
      when 'bice'     then bottom_of_icebox
      when 'bicebox'  then bottom_of_icebox
      end
    end

    def self.find_by_id(id)
      new(Request.new("stories/#{id}", {}, :get).result)
    end

    def self.top_of_backlog
      find(["state:unstarted", "limit:1"]).first
    end

    def self.top_of_icebox
      find(["state:unscheduled", "limit:1"]).first
    end

    def self.bottom_of_backlog
      find(["state:unstarted"]).last
    end

    def self.bottom_of_icebox
      find(["state:unscheduled"]).last
    end

    def self.just_url(id)
      if id
        "#{base_site_url}/stories/#{id}"
      else
        base_site_url
      end
    end

    def self.images_url(id)
      "#{just_url(id)}/images"
    end

    def self.base_site_url
      "https://www.pivotaltracker.com/s/projects/#{Yapt.project_id}"
    end

    attr_reader :raw_story
    def initialize(raw_story)
      @raw_story = raw_story
    end

    [:url, :story_type, :description, :id,
     :current_state, :labels, :owned_by_id, :created_at, :kind,
     :project_id, :requested_by_id, :updated_at, :name].each do |attr|
       define_method attr do
         raw_story[attr.to_s]
       end
    end

    def owner_initials
      if owned_by_id
        "Owner: #{Member.find(owned_by_id).initials}"
      else
        "No owner"
      end
    end

    def requester_initials
      "Requester: #{Member.find(requested_by_id).initials}"
    end

    def created_at_display
      "Created: #{time_display(created_at)}"
    end

    def updated_at_display
      "Updated: #{time_display(updated_at)}"
    end

    def time_display(time)
      Time.parse(time).strftime("%a %d%b %I:%M")
    end
  end
end
