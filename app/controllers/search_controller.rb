class SearchController < ApplicationController
  def search_results
    @query = params[:q]
    @processes_results = []
    @tasks_results = []
    @roles_results = []
    @are_all_empty = false
    
    query_string = get_query_string + " AND name LIKE '%%#{@query}%%'"
    
    processes_results = ProcessLt.where([query_string])
    processes_results.each do |proc|
      @processes_results.push({ :name => proc.name, :description => proc.description, :url => process_lt_path(proc) })
      @are_all_empty = true;
    end
    
    tasks_results = Task.where([query_string])
    tasks_results.each do |task|
      @tasks_results.push({ :name => task.name, :description => task.description, :url => task_path(task) })
      @are_all_empty = true;
    end
    
    roles_results = Role.where([query_string])
    roles_results.each do |role|
      @roles_results.push({ :name => role.name, :description => role.description, :url => role_path(role) })
      @are_all_empty = true;
    end
  end
end
