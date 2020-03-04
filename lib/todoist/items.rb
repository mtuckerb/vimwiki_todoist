# frozen_string_literal: true

class Todoist::Items 
  include Enumerable

  attr_accessor :all

  def initialize(items)
    @all = items.map { |item| Item.new(item)} unless @all
  end

  def to_a
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
 attr_accessor :item

  def initialize(item)
    @item = item
  end


  def method_missing(method, *_args)
    item.dig(method.to_s)
  end

end
