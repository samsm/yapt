require 'yaml'

module Yapt
  class Config
    attr_reader :project_path
    def initialize(project_path)
      @project_path = project_path
    end

    %w(project_id api_token github_url_base).each do |attr|
      define_method attr do
        config.fetch(attr)
      end
    end

    private

    def load_or_hash(path)
      YAML.load_file(path) rescue Hash.new
    end

    def config
      @config ||= user_config.merge(project_config)
    end

    def project_config
      load_or_hash("#{project_path}/.yapt")
    end

    def user_config
      load_or_hash("#{Dir.home}/.yapt")
    end
  end
end
