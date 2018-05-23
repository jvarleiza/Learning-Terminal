module PermissionsHelper
    def can_edit_content
        @user.user_a_dep.include?(cookies[:department_code]) || @user.is_global_admin
    end
    
    def is_global_admin
        @user.is_global_admin
    end
    
    def show_available_translations
        return cookies[:language_code] == 'en'
    end
end