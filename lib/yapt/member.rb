require "yaml"

module Yapt
  class Member
    def self.find(id)
      new all.detect {|u| u["person"]["id"] == id }
    end

    attr_reader :membership
    def initialize(membership)
      @membership = membership
    end

    def initials
      membership["person"]["initials"]
    end

    def self.all
      @memberships ||= cache[:results]
    end

    def self.cache
      cache = YAML.load_file(Yapt.tracker_member_cache)
      puts "Cache expiration in #{cache[:expires_at] - Time.now} seconds"
      cache[:expires_at] > Time.now ? cache : generate_cache
    end

    def self.generate_cache
      results = Request.new("memberships").result
      to_cache = { results: results, expires_at: Time.now + Yapt.cache_duration }
      File.open(Yapt.tracker_member_cache, 'w') {|f| f.write to_cache.to_yaml }
      to_cache
    end
  end
end
