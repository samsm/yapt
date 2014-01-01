require "rest-client"
require "json"

module Yapt
  class Request
    attr_reader :method, :path, :params
    def initialize(path, params = {}, method = :get)
      @method, @path, @params = method, path, params
    end

    def result
      request(method, params)
    end

    def request(method, payload)
      options = {
          "X-TrackerToken" => Yapt.api_token,
          "Content-Type" => "application/json"
        }
      response_handling = ->(response, request, result, &block) {
        case response.code
        when 200
          JSON.parse(response.to_s)
        else
          puts "Non-200 response!"
          puts response.to_s
        end
      }
      if method == :get
        RestClient.get(url, options.merge(params: payload), &response_handling)
      else
        RestClient.send(method, url, payload, options, &response_handling)
      end
    end

    def url
      "#{self.class.base_url}/#{path}"
    end

    def self.base_url
      "https://www.pivotaltracker.com/
       services/v5/projects/#{Yapt.project_id}".gsub(/\s+/,'')
    end
  end
end
