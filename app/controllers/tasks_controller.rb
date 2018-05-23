class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :duplicate]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = []
    role_id = params[:roleId]
    today = Date.today
    days_from_this_week = (today.at_beginning_of_week..today.at_end_of_week).to_a
    query_str = get_query_string({department_filter: true})
    query_str = query_str + " AND id IN (SELECT task_id FROM roles_tasks WHERE role_id = #{role_id})" if !role_id.blank?
    
    
    tasks_result = Task.where([query_str])
    days_from_this_week.each do |day|
      tasks_result.each do |task|
        new_task = task.dup
        new_task.start = task.mark_start ? day + task.hour_start.hours + task.min_start.minutes : day
        
        new_task.end = task.mark_start ? new_task.start + task.duration.minutes : new_task.start + 1.days
        new_task.id = task.id
        
        if task.task_type == 'daily' || day.wday == task.day_of_week || (!@tasks.include?(new_task) && task.day_of_week == -1)
          @tasks.push new_task
        end
      end
    end
    
    @roles_for_dept = Role.where([get_query_string({department_filter:true})]).order(:name)
  end
  
  def index_admin
    @tasks = Task.where([ get_query_string({is_admin: true, department_filter: true}) ]).order(:inactive)
    
    @lang_per_item = Hash.new
    available_langs = Hash.new
    
    @tasks.each do |i|
      available_langs[i.id] = Task.distinct.where(["origin = #{i.id}"]).pluck(:locale)
      @lang_per_item[i.id] = @languages.select do |key, value|
        # remove english beacuse it is the default one
        !available_langs[i.id].include?(key) && key != 'en'
      end
    end
  end
  
  def index_form
    @tasks = Task.where([get_query_string({locale: params[:loc]})])
    render action: "index"
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    # Dont show content if it is restricted and user is not in the department
    if is_content_restricted_or_inactive @task
      redirect_to not_allowed_path
    else
      @quality_tip = get_random_quality_tip
      user_bookmarks = Bookmark.find_by_user(@remote_user)
      @is_bookmarked = !user_bookmarks.blank? && user_bookmarks.tasks.include?(@task.id.to_s)
      
      trans_query = "(origin = #{@task.origin || @task.id} OR id = #{@task.origin || @task.id}) AND id <> #{@task.id}"
      @translations = Task.where([trans_query])
        .map {|i| {name: i.name, url: task_path(i.id), locale: @languages[i.locale]}}
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
    common_new_behavior
  end

  # GET /tasks/1/edit
  def edit
    common_edit_behavior @task, 'task'
  end
  
  # GET /tasks/duplicate/:id/:locale
  # gets the view for duplicating a task in another language
  def duplicate
    @selected_locale = params[:locale]
    @selected_language = @languages[@selected_locale]
    common_duplicate_behavior @task, 'task', @selected_locale
  end
  
  # POST /process_lt/duplicate
  def duplicate_create
    selected_locale = params[:selectedLocale]
    entity_id = params['entity-id']
    @task = Task.new(task_params)
    @task.locale = selected_locale
    @task.origin = entity_id
    update_task_color
    
    if @task.save
      update_related_ids_and_reverse()
      update_restricted_in_all_languages()
      redirect_to :controller => 'tasks', :action => 'index_admin'
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    update_task_color
    @task.start = Date.today
    @task.end = Date.today
    respond_to do |format|
      if @task.save
        update_related_ids_and_reverse()
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if params[:isDuplicate]
      duplicate_create
    else
      update_task_color
      if @task.update(task_params)
        update_related_ids_and_reverse
        update_restricted_in_all_languages
        redirect_to controller: 'tasks', action: 'index_admin', notice: 'Task was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :task_type, :locale, :departments, :countries, 
                                  :building_types, :related_attachments, :related_links, :inactive,
                                  :day_of_week, :hour_start, :min_start, :duration, :mark_start, :restricted)
    end
    
    def update_related_ids_and_reverse
      rev_entities_collection = update_related_ids @task
      rev_entities_collection.each do |ent|
        if !ent.tasks.include? @task
          ent.tasks << @task
        end
      end
    end
    
    def update_task_color
      @task.color = case
        when @task.task_type == 'daily'; @app_config['task-colors']['daily']
        when @task.task_type == 'weekly'; @app_config['task-colors']['weekly']
        when @task.task_type == 'bi_weekly'; @app_config['task-colors']['bi_weekly']
        when @task.task_type == 'monthly'; @app_config['task-colors']['monthly']
        when @task.task_type == 'quarterly'; @app_config['task-colors']['quarterly']
        when @task.task_type == 'bi_annually'; @app_config['task-colors']['bi_annually']
        when @task.task_type == 'annually'; @app_config['task-colors']['annually']
        else; 'black'
        end
    end
    
    def update_restricted_in_all_languages
      sql_query = "origin = #{@task.origin || @task.id}"
      sql_query = sql_query + " OR id = #{@task.origin}" if !@task.origin.blank?
      Task.where([sql_query]).update_all(restricted: @task.restricted)
    end
end
