class Admin::CompanyGroupsController < ApplicationController
  # BASE CONTROLLER >  
  layout 'admin/admin'
  helper :action_link
  # BASE CONTROLLER >

  def index
    @groups = CompanyGroup.ascend_by_name
  end
  
  def new
    @group = CompanyGroup.new    
  end
  
  def create
    @group = CompanyGroup.new(params[:company_group])
    if @group.save
      redirect_to :action => :index
    else
      render :new
    end
  end
  
  def edit
    @group = CompanyGroup.find(params[:id])
  end
  
  def update
    @group = CompanyGroup.find(params[:id])
    if @group.update_attributes(params[:company_group])
      redirect_to :action => :index
    else
      render :edit
    end
  end
  
  def destroy
    @group = CompanyGroup.find(params[:id])
    @group.destroy
    redirect_to :action => :index
  end
end
