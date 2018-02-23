require('sinatra')
require('sinatra/reloader')
require('./lib/task')
require('./lib/list')
also_reload('lib/**/*.rb')
require("pg")
require("pry")

# Important Note: When app.rb runs, it is written to use the to_do database. In order for our integration specs to pass, we need to use the to_do_test database. This can be accomplished by temporarily adding DB = PG.connect({:dbname => "to_do_test"}) to our app.rb file (which will need to be changed back to to_do after testing).

DB = PG.connect({:dbname => "to_do_test"})

get("/") do
  @lists = List.all()
  erb(:index)
end

get("/lists/new") do
  erb(:list_form)
end

get("/lists") do
 @lists = List.all()
 erb(:lists)
end

post("/lists") do
  name = params.fetch("name")
  list = List.new({:name => name, :id => nil})
  list.save()
  erb(:success)
end

get("/lists/:id") do
  @list = List.find(params.fetch("id").to_i())
  erb(:list)
end

post("/tasks") do
  # binding.pry
  description = params.fetch("description")
  list_id = params.fetch("list_id").to_i()
  @list = List.find(list_id)
  @task = Task.new({:description => description, :list_id => list_id})
  @task.save()
  erb(:task_success)
end


# patch("/lists/:id") do
#   name = params.fetch("name")
#   @list = List.find(params.fetch("id").to_i())
#   @list.update({:name => name})
#   erb(:list)
# end
#
# delete("/lists/:id") do
#   @list = List.find(params.fetch("id").to_i())
#   @list.delete()
#   @lists = List.all()
#   erb(:index)
# end
