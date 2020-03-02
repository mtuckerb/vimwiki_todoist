require 'bundler/setup'
Bundler.require
require 'dotenv/load'
require 'json'

class Todoist
  API_KEY=ENV['API_KEY']
  include HTTParty

  base_uri "https://api.todoist.com/sync/v8/sync"

  def self.projects
    options = {
      body: {
        token: ENV['API_KEY'],
        resource_types: '["projects"]'
      }
    }
    response = post("", options)
    #JSON.parse response,  symbolize_names: true
  end
end
