# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
#  include AuthenticatedSystem
#  include RoleRequirementSystem

#  ActiveScaffold::DataStructures::Column.show_blank_record = false
  
#  filter_parameter_logging :password 
  
#  before_filter :admin_protection_filter
  
  helper :all # include all helpers, all the time

#  helper_method :role_admin_area
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '77f405cf4951a5bd83147bbd0b312736'
  
  def admin_protection_filter
    admin_filter if params[:controller] =~ /^admin/
  end
  
  def admin_filter
    access_denied if !has_role?("editor")
  end

  def has_role?(role)
    authorized? && current_user.has_role?(role)
  end
  
  def role_admin_area(role, &block)
    if authorized? && current_user.has_role?(role)
      block.call
    end
  end
  
end
