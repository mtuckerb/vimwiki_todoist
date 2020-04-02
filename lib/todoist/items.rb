# frozen_string_literal: true

class Todoist::Items 
  include Enumerable

  attr_accessor :all

  def initialize(items, project_id)
    @all = items.map { |item| Item.new(item, project_id)} unless @all
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
    @item = item
    @project_id = project_id
  end

  def save
    api = Todoist::Api.new
    api.add_item(self)
  end

  def to_todo
    ::Todo.new(content: self.content, 
               status: self.checked, 
               order: self.order, 
               foreign_id: self.project_id)
  end

  def to_ary
    [@item]
  end

  def method_missing(method, *_args)
    @item.dig(method)||@item.dig(method.to_s)
  end

end
