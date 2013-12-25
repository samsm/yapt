require 'dotenv'
Dotenv.load

module Yapt
  autoload :VERSION, "yapt/version"
  autoload :Story, "yapt/story"
  autoload :Filter, "yapt/filter"
  autoload :View, "yapt/view"
  autoload :Member, "yapt/member"
  autoload :Request, "yapt/request"

  def self.project_id
    @project_id ||= ENV['project_id']
  end

  def self.api_token
    @api_token ||= ENV['api_token']
  end

  def self.cache_duration
    @cache_validity_duration ||= ENV['yapt_cache_validity_duration'] || 3600
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
      puts
      puts Story.find(args)
      puts
      puts args.inspect
    end

    def members
      Member.cache
    end

    def moo
      puts "MOOOO"
    end
  end
end
