module Yapt
  autoload :VERSION, "yapt/version"
  autoload :Story, "yapt/story"
  autoload :Filter, "yapt/filter"
  autoload :View, "yapt/view"
  autoload :Member, "yapt/member"
  autoload :Request, "yapt/request"
  autoload :Config, "yapt/config"

  def self.config
    @config ||= Config.new(Dir.pwd)
  end

  def self.project_id
    config.project_id
  end

  def self.api_token
    config.api_token
  end

  def self.cache_duration
    3600
  end

  def self.tracker_member_cache
    File.expand_path "#{Dir.pwd}/.yapt_member_cache"
  end

  def self.member_lookup(id)
    Member.find(id)
  end

  class Runner < Boson::Runner
    # option :urgent, type: :boolean
    def list(*args)
      display_config = View.extract_display_config(args)
      start_time = Time.now
      @stories = Story.find(args)
      puts
      puts View.new(@stories).display(display_config)
      puts
      puts "Took #{Time.now - start_time} seconds."
      puts
    end

    def members
      Member.cache
    end

    def moo
      puts "MOOOO"
    end
  end
end
