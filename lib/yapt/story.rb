module Yapt
  class Story
    def self.find(options = ["limit=5"])
      params = Filter.parse(options)
      puts View.headline(params[:filter])
      puts
      results = Request.new("stories", params, :get).result
      View.display(results)
    end
  end
end
