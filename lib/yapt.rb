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
  autoload :Comment, "yapt/comment"
  autoload :GitView, "yapt/git_view"

  def self.config
    @config ||= Config.new(Dir.pwd)
  end

  def self.project_id
    config.project_id
  end

  def self.api_token
    config.api_token
  end

  def self.github_url_base
    config.github_url_base
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

  class GitLogShiv
    def self.find(since_until)
      result = `git log #{since_until}`
      commits = result.split(/^commit/).reverse.collect {|c| "commit#{c}" }
      commits.pop if commits.last == 'commit'
      commits.collect {|c| new(c) }
    end

    attr_reader :sha, :author, :tracker_ids, :message
    def initialize(message)
      lines = message.split("\n")
      @sha = lines.first[/\w+$/].strip
      author_line = lines[1]
      @author = author_line[/:[^<]+/].sub(/\A:/,'').strip
      just_message = lines[3..-1].join("\n")
      tracker_directives = just_message.scan(/\[.*\d+\]/)
      @tracker_ids = []
      tracker_directives.each do |directive|
        @tracker_ids << directive[/\d+/]
        just_message.gsub!(directive,'')
      end
      @message = just_message.strip
    end

    def github_link
      "#{Yapt.github_url_base}/commit/#{sha}"
    end

    def stories
      @stories ||= tracker_ids.collect {|t| Story.find(t) }
    end
  end

  class Runner < Boson::Runner
    attr_reader :start_time
    def initialize
      @start_time = Time.now
      super
    end

    def git(since_until)
      commits = GitLogShiv.find(since_until)
      output GitView.new(commits).display("git")
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
