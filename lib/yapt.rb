require 'pry'
require 'highline/import'

module Yapt
  autoload :VERSION, "yapt/version"
  autoload :Story, "yapt/story"
  autoload :Filter, "yapt/filter"
  autoload :View, "yapt/view"
  autoload :Member, "yapt/member"
  autoload :Request, "yapt/request"
  autoload :Config, "yapt/config"
  autoload :Move, "yapt/move"

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
    attr_reader :start_time
    def initialize
      @start_time = Time.now
      super
    end

    def list(*args)
      display_config = View.extract_display_config(args)
      @stories = Story.find(args)
      display_config ||= (@stories.length > 1) ? "simple" : "detail"
      output View.new(@stories).display(display_config)
    end

    def show(id)
      @story = Story.find(id)
      output View.new([@story]).display("detail")
    end

    def open(id = nil)
     system_open Story.just_url(id)
    end

    def images(id)
      system_open Story.images_url(id)
    end

    def move(id, destination)
      mover = Move.setup(id, destination)
      puts
      puts mover.description
      puts View.new([mover.to_move, mover.target]).display("simple")

      permission = ask("Make this move?  ").downcase
      if %w(y yes).include?(permission)
        mover.execute!
        puts "Moved!"
      else
        puts "Aborted. Oh well."
      end
    end

    private

    def system_open(whatever)
      puts "Opening: #{whatever}"
      system "open #{whatever}"
    end

    def output(str)
      puts
      puts str
      puts
      puts "Took #{Time.now - start_time} seconds."
      puts
    end
  end
end
