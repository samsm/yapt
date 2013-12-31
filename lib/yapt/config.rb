require 'yaml'

module Yapt
  class Config
    attr_reader :project_path
    def initialize(project_path)
      @project_path = project_path
    end

    def project_id
      config.fetch('project_id')
    end

    def api_token
      config.fetch('api_token')
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
