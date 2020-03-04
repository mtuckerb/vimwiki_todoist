require 'faraday'

class Todoist::Api
    def self.post(resource: "", options: {})
      options = options.merge({token: ENV['API_KEY']})
      ::Faraday.post("#{ENV["TODOIST_BASE_URI"]}#{resource}", options).body
    end

end
