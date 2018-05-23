# All controllers will inherit from this. Contrains logic for getting the
# remote user and logging to PMET.
class ApplicationController < ActionController::Base
  require 'terminal_user'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Be aware, if you use :reset_session as the strategy here Kerberos will
  # interfere since we determine the remote user not with sessions but with the
  # Kerberos token instead.
  protect_from_forgery with: :exception
  
  before_action :initialize_remote_user, :load_configurations, :set_locale, :check_permissions

  # Set @remote_user for all routes
  # Default to the Midway forwarded user and fall back to REMOTE_USER if available.
  # See this for other important header fields:
  #    https://w.amazon.com/index.php/Midway/HowTo/Deploying_the_SSL_Proxy#Modify_Service
  def initialize_remote_user
    if (params[:controller] != 'ping')
      @remote_user = case
        when request.env['HTTP_X_FORWARDED_USER']
          request.env['HTTP_X_FORWARDED_USER']
        
        when request.env['REMOTE_USER']
          request.env['REMOTE_USER'].chomp('@ANT.AMAZON.COM')
          
        else
          # For testing in workspace without sentry or midway
          ENV['REMOTE_USER']
        end
        
      @remote_user = 'leizagj' if @remote_user.blank?
      @user = TerminalUser.new(@remote_user)
      
      # @remote_user = 'tobirich' #ICQA Admin
      # @remote_user = 'fusser'   #ICQA global user
      # @remote_user = 'krzysztw'
      # @remote_user = 'baumgarc'
      # @remote_user = 'caterinp' #ICQA User
      # @remote_user = 'leizagj'
      # @user = TerminalUser.new(@remote_user)
    end
  end
  
  def load_configurations
    @countries = JSON.parse(File.read('public/assets/config/countries.json'))
    @departments  = JSON.parse(File.read('public/assets/config/departments.json'))
    @business_units  = JSON.parse(File.read('public/assets/config/business_units.json'))
    @languages = JSON.parse(File.read('public/assets/config/languages.json'))
    @app_config = JSON.parse(File.read('public/assets/config/config.json'))
    @days_of_week = @app_config['days-of-week']
    set_user_filters_on_cookies
    configure_allowed_lists
    
    # This is getting all the tasks that are daily or set for these day, no matter the task_type
    # @today_tasks = get_tasks_for_today(
    #   Task.where(["inactive = 0 AND locale = ? AND start <= DATE(NOW()) AND end >= DATE(NOW())", cookies[:language_code]]))
    query_str = get_query_string({department_filter: true, locale: 'en'})
    @today_tasks = Task.where([query_str + " AND (day_of_week = DAYOFWEEK(NOW())-1 OR task_type = 0)"])
  end

  around_action :with_query_logging

  # If a controller needs to add to the query log entry
  def query_log_entry
    @top_query_log_entry
  end

  private
    def check_permissions
      if !@user.nil?
        controllers = ['process_lts', 'quality_tips', 'roles', 'tasks']
        controllers_g = ['quality_tips']
        edit_actions = ['new', 'edit', 'create', 'update', 'index_admin', 'roles_admin', 'tasks_admin', 'process_lts_admin', 'quality_tips_admin']
        user_editing_g = controllers_g.include?(params[:controller]) && edit_actions.include?(params[:action])
        user_is_global_admin = @user.is_global_admin
        user_can_edit_dept = @user.user_a_dep.include?(cookies[:department_code]) || user_is_global_admin
        user_is_editing = controllers.include?(params[:controller]) && edit_actions.include?(params[:action])
        
        user_editing_global_and_allowed = (user_editing_g && user_is_global_admin) || !user_editing_g
        
        user_is_legal = ((user_can_edit_dept && user_is_editing) || !user_is_editing) && 
                        user_editing_global_and_allowed
        
        redirect_to not_allowed_path unless user_is_legal
      end
    end
  
    # This method wraps all other methods/routes and creates a new query log.
    def with_query_logging
      query_log_entry = Amazon::QueryLog::Entry.new("#{params[:controller]}/#{params[:action]}", @request_id)
      @top_query_log_entry = query_log_entry
  
      query_log_entry['RemoteIpAddress'] = request.env['HTTP_X_FORWARDED_FOR']
      query_log_entry['UserAgent'] = request.env['HTTP_USER_AGENT']
      query_log_entry['RequestMethod'] = request.env['REQUEST_METHOD']
      query_log_entry['URL'] = request.fullpath
      query_log_entry['QueryString'] = request.env['QUERY_STRING']
      query_log_entry['RemoteUser'] = request.env['HTTP_X_FORWARDED_USER']
  
      # Yield to rails for rendering
      yield
    ensure
      # Always write the log entry (even if we threw an exception)
      query_log_entry['EndTime'] = Time.now.utc
      query_log_entry.time = query_log_entry['EndTime'] - query_log_entry.start_time
      Amazon::QueryLog.puts(query_log_entry)
    end
    
    # -------------------------------------------------------------------------------
    # CUSTOM METHODS
    # -------------------------------------------------------------------------------
    
    # Gets randomly a quality tip to display in page.
    def get_random_quality_tip
      QualityTip.where([
        "locale = ? AND departments LIKE ? AND inactive = 0", cookies[:language_code], "%#{cookies[:department_code]}%"
        ]).order("RAND()").limit(1).to_a[0]
    end
    
    # Updates values of cookies on every user request.
    # The :counter is to indicate if if is the first time the user access the site
    def set_user_filters_on_cookies
      if cookies[:counter].nil?
        cookies[:counter] = 1;
        cookies[:department_code] = @user.nil? ? 'icqa' : @user.default_department
        cookies[:country_code] = "All"
        cookies[:business_unit_code] = "All"
        # By default the language is going to be english
        cookies[:language_code] = "en"
      else
        if params[:c] && params[:d] && params[:b] && params[:lang]
          cookies[:country_code] = URI.decode(params[:c])
          cookies[:department_code] = URI.decode(params[:d])
          cookies[:business_unit_code] = URI.decode(params[:b])
          cookies[:language_code] = URI.decode(params[:lang])
        end
        cookies[:counter] = cookies[:counter].to_i + 1;
      end
      
      cookies[:country] = @countries[cookies[:country_code]]
      cookies[:department] = @departments[cookies[:department_code]]
      cookies[:business_unit] = @business_units[cookies[:business_unit_code]]
      cookies[:language] = @languages[cookies[:language_code]]
    end
    
    # Sets the locale from cookie or defaults to english
    def set_locale
      I18n.locale = cookies[:language_code] || I18n.default_locale
    end
    
    # Get entities with filters
    # {is_admin: 0/1, department_filter: 0/1}
    def get_query_string f = nil
      dept_code = params[:dept]
      entity_id = params[:e_id]
      
      #Filter first by parameters received
      query_str = '1=1'
      if !f.nil? && !f[:locale].blank?
        query_str = query_str + " AND locale = '#{f[:locale]}'"
      elsif !f.nil? && f[:no_locale]
        query_str = query_str
      else
        query_str = query_str + " AND locale = '#{cookies[:language_code]}'"
      end
      
      query_str = query_str + " AND id <> #{entity_id}" if !entity_id.blank?
      query_str = query_str + " AND departments = '#{dept_code}'" if !dept_code.blank?
      
      #Filter then by hash with options
      query_str = query_str + " AND inactive = false" if (f.nil? || f[:is_admin].nil?)
      query_str = query_str + " AND (countries LIKE '%%#{cookies[:country_code]}%%' OR countries LIKE '%%All%%')" if cookies[:country_code] != 'All'
      query_str = query_str + " AND (building_types LIKE '%%#{cookies[:business_unit_code]}%%' OR building_types LIKE '%%All%%')" if cookies[:business_unit_code] != 'All'
      query_str = query_str + " AND departments LIKE '%%#{cookies[:department_code]}%%'" if (!f.nil? && !f[:department_filter].nil?)
      
      return query_str
    end
    
    # Generic update of the related entities on form submit
    def update_related_ids entity
      entity.roles.clear
      entity.process_lts.clear
      entity.tasks.clear
      
      rel_roles = params[:rel_roles_ids].split('@@')
      rel_processes = params[:rel_processes_ids].split('@@')
      rel_tasks = params[:rel_tasks_ids].split('@@')
      
      rev_entities_collection = []
      
      rel_roles.each do |id|
        ent = Role.find(id)
        entity.roles << ent
        rev_entities_collection.push(ent)
      end
      rel_processes.each do |id|
        ent = ProcessLt.find(id)
        entity.process_lts << ent
        rev_entities_collection.push(ent)
      end
      rel_tasks.each do |id|
        ent = Task.find(id)
        entity.tasks << ent
        rev_entities_collection.push(ent)
      end
      return rev_entities_collection
    end
    
    def configure_allowed_lists
      @departments_f = []
      if !@user.nil?
        @departments_f = @user.is_global_admin ? @departments : @departments.select {|key, val| @user.user_a_dep.include? key}
      end
    end
    
    def common_new_behavior
      # get related content for new forms
      query_str = get_query_string({locale: 'en'})
      query_str = query_str + " AND departments = '#{@departments_f.keys[0]}'" if !@departments_f.blank?
      @rel_roles = Role.where([query_str])
      @rel_processes = ProcessLt.where([query_str])
      @rel_tasks = Task.where([query_str])
    end
    
    def common_edit_behavior ent, type = '', locale = nil
      # get related content for edit forms
      query_str = get_query_string({locale: locale || ent.locale}) + " AND departments = '#{ent.departments}'"
      query_str_for_own = query_str + " AND id <> #{ent.id}"
      @rel_roles = Role.where([type == 'role' ? query_str_for_own : query_str])
      @rel_processes = ProcessLt.where([type == 'process_lt' ? query_str_for_own : query_str])
      @rel_tasks = Task.where([type == 'task' ? query_str_for_own : query_str])
    end
    
    def common_duplicate_behavior ent, type, locale
      # get related content for duplicate in another language forms
      query_str = get_query_string({no_locale: true}) + " AND departments = '#{ent.departments}'"
      query_str = query_str + " AND (locale = '#{locale}' OR locale = '#{ent.locale}')"
      query_str_for_own = query_str + " AND id <> #{ent.id}"
      
      all_roles = Role.where([type == 'role' ? query_str_for_own : query_str])
      all_processes = ProcessLt.where([type == 'process_lt' ? query_str_for_own : query_str])
      all_tasks = Task.where([type == 'task' ? query_str_for_own : query_str])
      
      translated_roles = all_roles.select {|item| item.origin != nil}
      translated_processes = all_processes.select {|item| item.origin != nil}
      translated_tasks = all_tasks.select {|item| item.origin != nil}
      
      original_roles = all_roles.select {|item| item.origin == nil}
      original_processes = all_processes.select {|item| item.origin == nil}
      original_tasks = all_tasks.select {|item| item.origin == nil}
      
      
      @rel_roles = translated_roles + original_roles.select {|item| !translated_roles.pluck(:origin).include? item.id.to_s}
      @rel_roles = @rel_roles + ent.roles.select {|item| !@rel_roles.pluck(:id).include? item.id}
      
      @rel_processes = translated_processes + original_processes.select {|item| !translated_processes.pluck(:origin).include? item.id.to_s} 
      @rel_processes = @rel_processes + ent.process_lts.select {|item| !@rel_processes.pluck(:id).include? item.id}
      
      @rel_tasks = translated_tasks + original_tasks.select {|item| !translated_tasks.pluck(:origin).include? item.id.to_s} 
      @rel_tasks = @rel_tasks + ent.tasks.select {|item| !@rel_tasks.pluck(:id).include? item.id}
    end
    
    def is_content_restricted_or_inactive ent
      is_ok = @user.is_global_admin
      is_ok = is_ok || !ent.restricted
      is_ok = is_ok || (ent.restricted && @user.user_a_dep.include?(ent.departments))
      is_ok = is_ok || (ent.restricted && @user.user_u_dep.include?(ent.departments))
      is_ok = is_ok && !ent.inactive
      return !is_ok
    end
end
