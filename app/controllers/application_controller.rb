# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthlogicUser
  
  filter_parameter_logging :password, :password_confirmation

  helper_method :current_user_session, :current_user



#  include AuthenticatedSystem
#  include RoleRequirementSystem

#  filter_parameter_logging :password 
  
#  before_filter :login_filter
  
  helper :all # include all helpers, all the time

#  helper_method :role_admin_area
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '77f405cf4951a5bd83147bbd0b312736'
  
  
#   def admin_protection_filter
#     admin_filter if params[:controller] =~ /^admin/
#   end
  
#   def admin_filter
#     access_denied if !has_role?("editor")
#   end

#   def has_role?(role)
#     authorized? && current_user.has_role?(role)
#   end
  
#   def role_admin_area(role, &block)
#     if authorized? && current_user.has_role?(role)
#       block.call
#     end
#   end
  
#    ThinkingSphinx::ConnectionError



  # TODO Вынести эту заплатку куда следует
  
  def get_current_city
    City.find_by_name("Чебоксары")
  end

  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError,
              ActionController::UnknownAction,
#              ThinkingSphinx::ConnectionError,
              :with => :page_not_found

  rescue_from Acl9::AccessDenied, :with => :access_denied

  protected

  def page_not_found
    render 'home/page_not_found', :status => 404
  end

  def access_denied
    if current_user
      render :template => 'home/access_denied'
    else
      flash[:notice] = 'Access denied. Try to log in first.'
      redirect_to login_path
    end
  end

end
