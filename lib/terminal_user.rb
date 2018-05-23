# Call by @user = TerminalUser.new(@remote_user)
# Use by @user.level
#require 'net/ldap'

class TerminalUser
  attr_accessor :first_name, :last_name, :full_name, :email, :country, :city, :phone, :uid, :groups, :access_level, :level, 
  :employee_number, :location, :warehouse, :managerstr, :manageruid, :job_title, :department, :department_number, :business_unit, 
  :profilePath, :company, :lt_groups, :user_u_dep, :user_a_dep, :is_global_admin, :default_department

  # @user = AmazonUser.new(@remote_user)
  def initialize(username)
    #ldServer = LdapUrl.where(active: 1).first.URL
    #attributes = ["mail", "uid", "givenname", "sn", "amzncity", "co", "telephonenumber", "employeenumber", "amznlocdescr"]
    filter = Net::LDAP::Filter.eq('uid', username)
    ldap = Net::LDAP.new(:host => "ldap.amazon.com", :port => 389)
    user = ldap.search(:base => "o=amazon.com", :filter => filter)
    # puts user[0].amznjobcode
    if !user.empty?
      @first_name = user[0]["givenname"][0]
      @last_name = user[0]["sn"][0]
      @full_name = user[0]["gecos"][0]
      @email = user[0]["mail"][0]
      @country = user[0]["co"][0]
      @city = user[0]["amzncity"][0]
      @phone = user[0]["telephonenumber"][0]
      @uid = user[0]["uid"][0]
      @level = user[0]["amznjobcode"][0]
      @employee_number = user[0]["employeenumber"][0]
      @location = user[0]["amznlocdescr"][0]
      @warehouse = parse_warehouse_from_location
      @managerstr = user[0]["manager"][0]
      @manageruid = parse_mgruid_from_manager
      @job_title = user[0]["description"][0]
      
      @department = user[0]["amzndeptname"][0]
      @department_number = user[0]["departmentnumber"][0]
      @business_unit = user[0]["amznbusinessunit"][0]

      @groups = Array.new
      group_results = ldap.search(base: "ou=Groups,o=amazon.com", attributes: ['objectclass'], filter: Net::LDAP::Filter.eq('memberuid',username))
      group_results.each { |g| @groups.push(g['dn'][0].split(',')[0].gsub(/^cn=/,""))} unless group_results.nil?
      
      @lt_groups = @groups.select {|item| item.include? 'learning-terminal'}
      @user_u_dep = @lt_groups.select {|dep| dep.split('-')[3] == 'user'}.map {|dep| dep.split('-')[2]}
      @user_a_dep = @lt_groups.select {|dep| dep.split('-')[3] == 'admin'}.map {|dep| dep.split('-')[2]}
      @is_global_admin = @user_a_dep.include? 'global'
      @user_a_dep = @user_a_dep.select {|dep| dep != 'global'}
      @default_department = @user_u_dep.empty? ? @user_a_dep.empty? ? 'icqa' : @user_a_dep[0] : @user_u_dep[0]

    else
      @first_name = "UNKNOWN"
    end # user empty
  end # initialize


    # @user.has_group('Case-Sensitive-Group')
  def has_group(name)
    return (!self.groups.nil? ? Set.new(self.groups.map(&:downcase)).include?(name.downcase) : false)
  end # has_group

  # @user.parse_warehouse_from_location
  def parse_warehouse_from_location
  # :amznlocdescr=>["IND1 - Whitestown, IN"],

    /(?<wh>\w+) - .*/ =~ self.location
    /(?<wh>\w+)- .*/ =~ self.location if wh.nil?
    /(?<wh>\w+)-.*/ =~ self.location if wh.nil?
    wh
  end # parse_warehouse_from_location

  # @user.parse_mgruid_from_manager
  def parse_mgruid_from_manager
  # :manager=>["cn=Jeffrey Jones (jefjones),ou=people,ou=us,o=amazon.com"],

    /\((?<mgr>[^)]+)\)/ =~ self.managerstr
      #     \( : match an opening parentheses
      #      ( : begin capturing group
      # ?<mgr> : put into variable
      #   [^)]+: match one or more non ) characters
      #      ) : end capturing group
      #     \) : match closing parentheses
    mgr
  end # parse_mgruid_from_manager

  def get_org_chart(username,orgchart=[])
    if !username.blank? || !username.nil?
      filter = Net::LDAP::Filter.eq('uid', username)
      ldap = Net::LDAP.new(:host => "ldap.amazon.com", :port => 389)
      user = ldap.search(:base => "o=amazon.com", :filter => filter)
      if !user.nil?
        /\((?<mgr>[^)]+)\)/ =~ user[0]["manager"][0].gsub("(Seattle)", "")
        if !mgr.nil?
          orgchart << mgr
          get_org_chart(mgr,orgchart) # Recursion to keep going up the org chart till we hit the ALL MIGHTY Jeff.
        end
      end
    end
    orgchart
  end

end # AmazonUser
