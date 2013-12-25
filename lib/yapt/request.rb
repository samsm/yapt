require "rest-client"

module Yapt
  class Request
    def initialize(path, params = {}, method = :get)
      @text_result = send(method, path, params)
    end

    def result
      JSON.parse(@text_result)
    end

    def get(path, params={})
      url = "#{base_url}/#{path}"
      RestClient.get url,
        {
          params: params,
          "X-TrackerToken" => Yapt.api_token
        }
    end

    def base_url
      "https://www.pivotaltracker.com/
       services/v5/projects/#{Yapt.project_id}".gsub(/\s+/,'')
    end
  end
end
