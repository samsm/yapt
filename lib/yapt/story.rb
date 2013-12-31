module Yapt
  class Story
    def self.find(options = ["limit=5"])
      return find_one(options) if options.kind_of?(String)
      params = Filter.parse(options)
      results = Request.new("stories", params, :get).result
      results.collect {|r| new(r) }
    end

    def self.find_one(id)
      new(Request.new("stories/#{id}", {}, :get).result)
    end

    def self.just_url(id)
      if id
        "https://www.pivotaltracker.com/s/projects/#{Yapt.project_id}/stories/#{id}"
      else
        "https://www.pivotaltracker.com/s/projects/#{Yapt.project_id}"
      end
    end

    def self.images_url(id)
      "https://www.pivotaltracker.com/projects/#{Yapt.project_id}/stories/#{id}/images"
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
