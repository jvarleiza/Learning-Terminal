class ProcessLtsController < ApplicationController
  before_action :set_process_lt, only: [:show, :edit, :update, :destroy, :duplicate]

  # GET /process_lts
  # GET /process_lts.json
  # TODO: Not being used
  def index
    # @process_lts = ProcessLt.where([get_query_string])
    index_admin
  end
  
  def index_admin
    @process_lts = ProcessLt.where([ get_query_string({is_admin: true, department_filter: true}) ])
    
    @lang_per_item = Hash.new
    available_langs = Hash.new
    
    @process_lts.each do |i|
      available_langs[i.id] = ProcessLt.distinct.where(["origin = #{i.id}"]).pluck(:locale)
      @lang_per_item[i.id] = @languages.select do |key, value|
        # remove english beacuse it is the default one
        !available_langs[i.id].include?(key) && key != 'en'
      end
    end
    
    render action: "index"
  end
  
  def index_form
    @process_lts = ProcessLt.where([get_query_string({locale: params[:loc]})])
    render action: "index"
  end

  # GET /process_lts/1
  # GET /process_lts/1.json
  def show
    # Dont show content if it is restricted and user is not in the department
    if is_content_restricted_or_inactive @process_lt
      redirect_to not_allowed_path
    else
      @quality_tip = get_random_quality_tip
      user_bookmarks = Bookmark.find_by_user(@remote_user)
      @is_bookmarked = !user_bookmarks.blank? && user_bookmarks.processes.include?(@process_lt.id.to_s)
      
      trans_query = "(origin = #{@process_lt.origin || @process_lt.id} OR id = #{@process_lt.origin || @process_lt.id}) AND id <> #{@process_lt.id}"
      @translations = ProcessLt.where([trans_query])
        .map {|i| {name: i.name, url: process_lt_path(i.id), locale: @languages[i.locale]}}
    end
  end

  # GET /process_lts/new
  def new
    @process_lt = ProcessLt.new
    common_new_behavior
  end

  # GET /process_lts/1/edit
  def edit
    common_edit_behavior @process_lt, 'process_lt'
  end
  
  # GET /process_lt/duplicate/:id/:locale
  # gets the view for duplicating a process in another language
  def duplicate
    @selected_locale = params[:locale]
    @selected_language = @languages[@selected_locale]
    common_duplicate_behavior @process_lt, 'process_lt', @selected_locale
  end
  
  # POST /process_lt/duplicate
  def duplicate_create
    selected_locale = params[:selectedLocale]
    entity_id = params['entity-id']
    @process_lt = ProcessLt.new(process_lt_params)
    @process_lt.locale = selected_locale
    @process_lt.origin = entity_id
    
    if @process_lt.save
      update_related_ids_and_reverse()
      update_restricted_in_all_languages()
      redirect_to :controller => 'process_lts', :action => 'index_admin'
    end
  end

  # POST /process_lts
  # POST /process_lts.json
  def create
    @process_lt = ProcessLt.new(process_lt_params)

    respond_to do |format|
      if @process_lt.save
        update_related_ids_and_reverse()
        format.html { redirect_to @process_lt, notice: 'Process was successfully created.' }
        format.json { render :show, status: :created, location: @process_lt }
      else
        format.html { render :new }
        format.json { render json: @process_lt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /process_lts/1
  # PATCH/PUT /process_lts/1.json
  def update
    if params[:isDuplicate]
      duplicate_create
    else
      if @process_lt.update(process_lt_params)
        update_related_ids_and_reverse
        update_restricted_in_all_languages
        redirect_to controller: 'process_lts', action: 'index_admin', notice: 'Process was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /process_lts/1
  # DELETE /process_lts/1.json
  def destroy
    @process_lt.destroy
    respond_to do |format|
      format.html { redirect_to process_lts_url, notice: 'Process was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_lt
      @process_lt = ProcessLt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_lt_params
      params.require(:process_lt).permit(:name, :description, :content, :locale, :departments, 
                                          :countries, :building_types, :related_attachments, 
                                          :related_links, :inactive, :embeded_video, :restricted)
    end
    
    def update_related_ids_and_reverse
      rev_entities_collection = update_related_ids @process_lt
      
      rev_entities_collection.each do |ent|
        if !ent.process_lts.include? @process_lt
          ent.process_lts << @process_lt
        end
      end
    end
    
    def update_restricted_in_all_languages
      sql_query = "origin = #{@process_lt.origin || @process_lt.id}"
      sql_query = sql_query + " OR id = #{@process_lt.origin}" if !@process_lt.origin.blank?
      ProcessLt.where([sql_query]).update_all(restricted: @process_lt.restricted)
    end
end
