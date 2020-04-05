# frozen_string_literal: true
require 'active_support/hash_with_indifferent_access'
class Todoist::Items
  include Enumerable

  attr_accessor :all

  def initialize(items, project_id)
    @all ||= items.map { |item| Item.new(item, project_id) }
  end

  def to_a
    @all.to_a
  end

  def to_ary
    @all.to_a
  end

  def each(&block)
    @all.each(&block)
  end

  def method_missing(method, *_args)
    all.dig(method.to_s)
  end
end

class Todoist::Items::Item
  attr_accessor :item, :project_id

  def initialize(item, project_id)
    @item = ActiveSupport::HashWithIndifferentAccess.new item
    @project_id = project_id
  end

  def save
    api = Todoist::Api.new
    api.add_item(self)
  end

  def to_task
    Task.find_or_create_todo(OpenStruct.new(content: @item['content'], status: @item['checked'], order: @item['order'], foreign_id: project_id))
  end

  def to_ary
    [@item]
  end

  def method_missing(method, *_args)
    @item.dig(method) || @item.dig(method.to_s)
  end
end
