# frozen_string_literal: true
require "active_support/core_ext/hash/indifferent_access"

class Todo
  attr_accessor :content, :status, :order, :foreign_id

  def initialize(args)
    args = ActiveSupport::HashWithIndifferentAccess.new(args)
    @content = args.dig :content 
    @status = args.dig :status 
    @order = args.dig :order 
    @foreign_id = args.dig :foreign_id 
  end

  def to_todoist(project_id)
   Todoist::Items::Item.new({
      content: content,
      order: order,
      status: status,
      foreign_id: foreign_id
    },project_id) 
  end
end

