class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy, :duplicate]

  # GET /roles
  # TODO: Not being used
  def index
    # @roles = Role.where([get_query_string])
    index_admin
  end
  
  def index_admin
    @roles = Role.where([ get_query_string({is_admin: true, department_filter: true}) ])
    
    @lang_per_role = Hash.new
    available_langs = Hash.new
    
    @roles.each do |r|
      available_langs[r.id] = Role.distinct.where(["origin = #{r.id}"]).pluck(:locale)
      @lang_per_role[r.id] = @languages.select do |key, value|
        # remove english beacuse it is the default one
        !available_langs[r.id].include?(key) && key != 'en'
      end
    end
    render "index"
  end
  
  def index_form
    @roles = Role.where([get_query_string({locale: params[:loc]})])
    render "index"
  end

  # GET /roles/1
  def show
    # Dont show content if it is restricted and user is not in the department
    if is_content_restricted_or_inactive @role
      redirect_to not_allowed_path
    else
      @quality_tip = get_random_quality_tip
      user_bookmarks = Bookmark.find_by_user(@remote_user)
      @is_bookmarked = !user_bookmarks.blank? && user_bookmarks.roles.split('@@').include?(@role.id.to_s)
      
      # Get available translations for this role
      trans_query = "(origin = #{@role.origin || @role.id} OR id = #{@role.origin || @role.id}) AND id <> #{@role.id}"
      @translations = Role.where([trans_query])
        .map {|i| {name: i.name, url: role_path(i.id), locale: @languages[i.locale]}}
    end
  end

  # GET /roles/new
  def new
    @role = Role.new
    common_new_behavior
  end

  # GET /roles/1/edit
  def edit
    common_edit_behavior @role, 'role'
  end
  
  # GET /roles/duplicate/:id/:locale
  # gets the view for duplicating a role in another language
  def duplicate
    @selected_locale = params[:locale]
    @selected_language = @languages[@selected_locale]
    common_duplicate_behavior @role, 'role', @selected_locale
  end
  
  # POST /roles/duplicate
  def duplicate_create
    selected_locale = params[:selectedLocale]
    entity_id = params['entity-id']
    @role = Role.new(role_params)
    @role.locale = selected_locale
    @role.origin = entity_id
    
    if @role.save
      update_related_ids_and_reverse()
      update_restricted_in_all_languages()
      redirect_to :controller => 'roles', :action => 'index_admin'
    end
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    respond_to do |format|
      if @role.save
        update_related_ids_and_reverse()
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  def update
    if params[:isDuplicate]
      duplicate_create
    else
      if @role.update(role_params)
        update_related_ids_and_reverse
        update_restricted_in_all_languages
        redirect_to controller: 'roles', action: 'index_admin', notice: 'Role was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :description, :locale, :departments, :countries, :building_types, 
                                  :related_attachments, :related_links, :inactive, :restricted)
    end
    
    def update_related_ids_and_reverse
      rev_entities_collection = update_related_ids @role
      
      # TODO: remove all dependancies of entities towards @role
      # DELETE FROM `related_roles` WHERE `related_roles`.`role_b_id` = @role.id;
      
      rev_entities_collection.each do |ent|
        if !ent.roles.include? @role
          ent.roles << @role
        end
      end
    end
    
    def update_restricted_in_all_languages
      sql_query = "origin = #{@role.origin || @role.id}"
      sql_query = sql_query + " OR id = #{@role.origin}" if !@role.origin.blank?
      Role.where([sql_query]).update_all(restricted: @role.restricted)
    end
end