module Yapt
  class Comment
    def self.find(story_id)
      results = Request.new("stories/#{story_id}/comments", {}, :get).result
      results.collect {|r| new(r) }
    end

    attr_reader :raw
    def initialize(data)
      @raw = data
    end

    [:person_id, :created_at, :updated_at, :text,
     :story_id, :id].each do |attr|
       define_method attr do
         raw[attr.to_s]
       end
    end

    def commenter
      @commenter ||= Member.find(person_id)
    end

    def created_at_display
      time_display(created_at)
    end

    def time_display(time)
      Time.parse(time).strftime("%a %d %b %I:%M")
    end
  end
end
