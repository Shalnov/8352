class Admin::BranchesController < ApplicationController
  # BASE CONTROLLER >
  layout 'admin/admin'
  helper :action_link
  # BASE CONTROLLER >
  
  def index
    @branches = Branch.with_groups.all
  end
  
  def new
    @branch = Branch.new
  end
  
  def create
    @branch = Branch.new(params[:branch])
    if @branch.save
      redirect_to :action => :index
    else
      render :new
    end
  end

  def edit
    @branch = Branch.find(params[:id])
  end

  def update
    @branch = Branch.find(params[:id])
    if @branch.update_attributes(params[:branch])
      redirect_to :action => :index
    else
      render :edit
    end
  end

  def destroy
    Branch.find(params[:id]).destroy
    redirect_to :action => :index
  end
  
  def move
    source_id = params[:source].gsub('branch_', '')
    source = Branch.find(source_id)    
    if params[:target]
      target_id = params[:target].gsub('branch_', '')
      target = Branch.find(target_id)
      source.move_to_left_or_right(target)
    elsif params[:target_parent]
      target_id = params[:target_parent].gsub('branch_', '')      
      source.move_to_child_of(target_id)
    end
    
    @branches = Branch.with_groups.all
    render :layout => false
  end
  
  def attach_group
    @branch = Branch.find(params[:id])
    @group = CompanyGroup.find(params[:group_id])
    @branch.groups << @group
    @branches = Branch.with_groups.all
    render :layout => false
  end        
  
  def detach_group
    @branch = Branch.find(params[:id])
    @group = CompanyGroup.find(params[:group_id])
    @branch.groups.delete(@group)
    @branches = Branch.with_groups.all
    redirect_to :action => :index
  end
end
