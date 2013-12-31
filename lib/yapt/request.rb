require "rest-client"

module Yapt
  class Request
    attr_reader :method, :path, :params
    def initialize(path, params = {}, method = :get)
      @method, @path, @params = method, path, params
    end

    def result
      execute!
      JSON.parse(@text_result)
    end

    def get(path, params={})
      RestClient.get url,
        {
          params: params,
          "X-TrackerToken" => Yapt.api_token
        }
    end

    def url
      "#{base_url}/#{path}"
    end

    private

    def base_url
      "https://www.pivotaltracker.com/
       services/v5/projects/#{Yapt.project_id}".gsub(/\s+/,'')
    end

    def execute!
      @text_result = send(method, path, params)
    end
  end
end
