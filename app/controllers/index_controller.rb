# Simple controller to render the index page. Feel free to use this as your
# home page or simply remove it.
class IndexController < ApplicationController
    def index
        @quality_tip = get_random_quality_tip
        @process_lts = get_content 'process_lts'
        @roles = get_content 'roles'
        @tasks = get_content 'tasks'
    end
    
    # GET listing/:type
    def listing
        @items = get_content params[:type]
        case params[:type]
            when 'process_lts'
                @title = 'Listing processes'
                @class_color = 'bg-green'
                map_list @items, method(:process_lt_path)
            when 'roles'
                @title = 'Listing roles'
                @class_color = 'bg-aqua'
                map_list @items, method(:role_path)
            when 'tasks'
                @title = 'Listing tasks'
                @class_color = 'bg-yellow'
                map_list @items, method(:task_path)
        end
    end
    
    def group
        @process_lts = map_list(get_content('process_lts'), method(:process_lt_path), true)
        @roles = map_list(get_content('roles'), method(:role_path), true)
        @tasks = map_list(get_content('tasks'), method(:task_path), true)
    end
    
    private
        def get_content type
            query_string = get_query_string({department_filter:true})
            list = case type
                when 'roles'
                    Role.where([query_string]).order(:name).select {|item| !is_content_restricted_or_inactive(item) }
                when 'process_lts'
                    ProcessLt.where([query_string]).order(:name).select {|item| !is_content_restricted_or_inactive(item) }
                when 'tasks'
                    Task.where([query_string]).order(:name).select {|item| !is_content_restricted_or_inactive(item) }
                else
                    []
            end
            return list
        end
        
        def map_list list, fn, full = false
            if full
                list.map! {|i| {id: i.id, url: fn.call(i), name: i.name, description: i.description, 
                roles: i.roles.pluck(:id), processes: i.process_lts.pluck(:id), tasks: i.tasks.pluck(:id) }}
            else
                list.map! {|i| {id: i.id, url: fn.call(i), name: i.name, description: i.description}}
            end
        end
end
