require "ostruct"

module Yapt
  class View
    extend Forwardable

    def_delegators :@story, :url, :story_type, :description, :id,
      :current_state, :labels, :owned_by_id, :created_at, :kind,
      :project_id, :requested_by_id, :updated_at, :name

    def self.headline(str)
      "About to display: #{str}"
    end

    def self.display(stories)
      stories.inject("") do |str, story|
        str + new(story).to_s
      end
    end

    attr_reader :story
    def initialize(story)
      @story = OpenStruct.new(story)
    end

    def to_s
      [:id, :story_type, :current_state, :name, :nl,
       :created_at_display, :updated_at_display,
       :owner_initials, :requester_initials,
       :nl, :nl
      ].inject("") do |str, element|
        str += "#{send(element)}"
        element == :nl ? str : "#{str} | "
      end.gsub(/\| $/, '')
    end

    private

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

    def id_name
      "#{story.id} | #{story.name}\n"
    end

    def nl
      "\n"
    end
  end
end
# ["url", "story_type", "description", "id", "current_state",
 # "labels", "owned_by_id", "created_at", "kind", "project_id",
 # "requested_by_id", "updated_at", "name"]

