module Yapt
  class Move
    def self.setup(id, target_id)
      to_move = Story.find(id)
      target = Story.find(target_id)
      new(to_move, target)
    end

    attr_reader :to_move, :target
    def initialize(to_move, target)
      @to_move, @target = to_move, target
    end

    def description
      "Move #{to_move.id} just above #{target.id}"
    end

    def params
      {
        before_id: target.id
      }
    end

    def execute!
      Request.new("stories/#{to_move.id}", params, :put).result
    end
  end
end
