class Admin::BranchesController < ApplicationController
  # BASE CONTROLLER >
  layout 'admin/admin'
  helper :action_link
  # BASE CONTROLLER >
  
  def index
    get_branches
    @groups = CompanyGroup.with_branches.ordered.all
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
  
  # Движения:
  #   - Целевая ветка - всегда бранч. 
  #   - Исходная - бранч или группа.
  #   - Бранч может быть дропнут на бранч.
  #   - Группа может быть дропнута на бранч.
  #   - Группа может быть склонирована - передаётся params[:clone]
  def move
    target_id = params[:target].gsub('branch_', '')
    
    if params[:source] =~ /branch/
      source_id = params[:source].gsub('branch_', '')
      source = Branch.find(source_id)    
      if target_id != 'root'
        target = Branch.find(target_id)
        source.move_to_child_of(target)
      else
        source.move_to_root
      end
    elsif params[:source] =~ /group/
      target = Branch.find(target_id)
      params[:source].match(/group_(\d+)(_parent_(\d+))?/)
      source_id = $1  
      old_parent_id = $3

      source = CompanyGroup.find(source_id)
      unless old_parent_id.nil? || params[:clone] == "true"
        old_parent = Branch.find(old_parent_id)
        old_parent.groups.delete(source)
      end

      source.branches << target unless source.branches.include?(target)      
      source.save!
    end
    
    get_branches
    render :layout => false
  end
  
  def detach_group
    @branch = Branch.find(params[:id])
    @group = CompanyGroup.find(params[:group_id])
    @branch.groups.delete(@group)
    @branches = Branch.with_groups.all
    
    get_branches
    render :layout => false
  end
  
protected
  def get_branches
    @branches = Branch.with_groups.all
  end
end
