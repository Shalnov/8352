class Admin::RolesController < ApplicationController
  before_filter :admin_filter
  
  layout 'admin'

  active_scaffold :roles do |config|
    config.columns = [:name, :users]
  end
  
private  
  def admin_filter
    access_denied if !has_role?("admin")
  end
end