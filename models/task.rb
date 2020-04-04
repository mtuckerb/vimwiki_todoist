# frozen_string_literal: true

class Task < Sequel::Model
  def self.find_or_create_todo(todo)
    new_task = Task.find_or_create(content: todo.content){ |t| t.created_at = Time.now }
    new_task.order = todo.order
    new_task.status = set_status(new_task.status, todo.status)
    new_task.foreign_id = todo.foreign_id
    new_task.save
  end

  def to_todoist(project_id)
   Todoist::Items::Item.new({
      content: content,
      order: order,
      checked: status,
      foreign_id: foreign_id
    },project_id) 
  end

  private
  
  def self.set_status(now, new)
    if now == true || new == true
      true
    else
      false
    end
  end
end
