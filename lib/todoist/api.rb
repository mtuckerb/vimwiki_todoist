# frozen_string_literal: true

require 'faraday'
require 'securerandom'

class Todoist::Api
  attr_accessor :response, :request

  def post(resource: "", options: {})
    options = options.merge(token: ENV['API_KEY'])
    @request = "#{ENV['TODOIST_BASE_URI']}#{resource}/#{options}"
    @response = ::Faraday.post("#{ENV['TODOIST_BASE_URI']}#{resource}", options).body
  end

  def add_items(items)
    items = items.is_a?(Array) ? items : [items]

    post(resource: "sync", options: {
           "sync_token": "*",
           "resource_types": ["projects", "items"],
           "commands": item_commands(items, type: "item_add")
         })
  end

  def update_items(_item)
    items = items.is_a?(Array) ? items : [items]
    post(resource: "sync", options: {
           "sync_token": "*",
           "resource_types": ["projects", "items"],
           "commands": item_commands(items, type: "item_update")
         })
  end

  def get_projects
    options = { resource_types: '["projects"]', sync_token: "*" }
    responses = post(resource: "sync", options: options)
    JSON.parse(responses).dig("projects") || {}
  end

  private

  def item_commands(items, type:)
    commands = items.map do |item|
      { type: :type,
        temp_id: create_uuid,
        uuid: create_uuid,
        args: {
          project_id: item.project_id,
          content: item.content
        } }
    end
    commands.to_json
  end

  def create_uuid
    SecureRandom.uuid
  end
end
