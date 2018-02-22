class Task
  attr_reader(:description, :list_id)

  def initialize(attributes)
    @description = attributes.fetch(:description)
    @list_id = attributes.fetch(:list_id)
  end

  def self.all
    # select * from tasks order by due_date desc;
    returned_tasks = DB.exec("SELECT * FROM tasks ORDER BY due_date;")
    tasks = []
    returned_tasks.each() do |task|
      description = task.fetch("description")
      list_id = task.fetch("list_id").to_i() # The information comes out of the database as a string.
      tasks.push(Task.new({:description => description, :list_id => list_id}))
    end
    tasks
  end

  def save
    DB.exec("INSERT INTO tasks (description, list_id) VALUES ('#{@description}', #{@list_id});")
  end

  def ==(another_task)
    self.description().==(another_task.description()).&(self.list_id().==(another_task.list_id()))
  end
end
