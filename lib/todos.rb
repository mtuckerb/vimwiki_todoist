# frozen_string_literal: true

class Todos
  include Enumerable
  attr_accessor :todos

  def initialize(items: nil)
    @todos = []
    if items.is_a?(Array) && !items.empty?
      items.each{ |i| push(i) }
    elsif items.is_a?(Todo)
      push(items)
    end
  end

  def to_a
    todos
  end

  def to_ary
    todos
  end

  def [] index
    @todos[index]
  end

  def each(&block)
    todos.each(&block)
  end

  def push(item)
    safe_item = item.is_a?(Todo) ? item : to_todo(item)
    todos.push(safe_item)
  end

  def find_by(args)
    todos.find do |item|
      args.map{ |k, v| item.send(k) == v }.any?
    end
  end

  def to_todo(item, foreign_id: nil)
    item.merge(foreign_id: foreign_id) if foreign_id
    Todo.new(item)
  end
end
