class BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update, :create]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @roles_results = []
    @processes_results = []
    @tasks_results = []
    
    user_bookmarks = Bookmark.find_by_user(@remote_user)
    roles = []
    processes = []
    tasks = []
    @roles_results = []
    @processes_results = []
    @tasks_results = []
    
    if !user_bookmarks.nil?
      roles = '(' + user_bookmarks.roles.split('@@').join(',') + ')' if !user_bookmarks.roles.blank?
      processes = '(' + user_bookmarks.processes.split('@@').join(',') + ')' if !user_bookmarks.processes.blank?
      tasks = '(' + user_bookmarks.tasks.split('@@').join(',') + ')' if !user_bookmarks.tasks.blank?
    end
    
    if !roles.blank?
      @roles_results = Role.where(["id IN #{roles} AND inactive = 0"]).order(:name)
        .map {|i| {name: i.name, description: i.description, url: role_path(i), locale: i.locale}}
    end
      
    if !processes.blank?
      @processes_results = ProcessLt.where(["id IN #{processes} AND inactive = 0"]).order(:name)
        .map {|i| {name: i.name, description: i.description, url: process_lt_path(i), locale: i.locale}}
    end
      
    if !tasks.blank?
      @tasks_results = Task.where(["id IN #{tasks} AND inactive = 0"]).order(:name)
        .map {|i| {name: i.name, description: i.description, url: task_path(i), locale: i.locale}}
    end
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    user = params[:user]
    ent_id = params[:entId]
    ent_type = params[:entType]
    
    @bookmark = Bookmark.find_by_user(user)
    
    if @bookmark.blank?
      @bookmark = Bookmark.new user: user, roles: '', processes: '', tasks: ''
    end
    
    if (ent_type == 'process_lt' && !@bookmark.processes.split('@@').include?(ent_id))
      @bookmark.processes = (@bookmark.processes.split('@@') << ent_id).join('@@')
    elsif (ent_type == 'role' && !@bookmark.roles.split('@@').include?(ent_id))
      @bookmark.roles = (@bookmark.roles.split('@@') << ent_id).join('@@')
    elsif (ent_type == 'task' && !@bookmark.tasks.split('@@').include?(ent_id))
      @bookmark.tasks = (@bookmark.tasks.split('@@') << ent_id).join('@@')
    end
    
    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully added.' }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    user = params[:user]
    ent_id = params[:entId]
    ent_type = params[:entType]
    
    @bookmark = Bookmark.find_by_user(user)
    
    if @bookmark.blank?
      @bookmark = Bookmark.new user: user, roles: '', processes: '', tasks: ''
    end
    
    if ent_type == 'process_lt'
      processes = @bookmark.processes.split('@@'); processes.delete(ent_id)
      @bookmark.processes = processes.join('@@')
    elsif ent_type == 'role'
      roles = @bookmark.roles.split('@@'); roles.delete(ent_id)
      @bookmark.roles = roles.join('@@')
    elsif ent_type == 'task'
      tasks = @bookmark.tasks.split('@@'); tasks.delete(ent_id)
      @bookmark.tasks = tasks.join('@@')
    end
    
    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully removed.' }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end
end
