class CompaniesController < ApplicationController
  access_control do
     allow all
  end

  def index
    @companies = params[:category_id] ? 
    Company.find_all_by_category_id(params[:category_id]) : 
      Company.find(:all,:limit=>50)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end
  
  def new
    @company = Company.new
    @company.phones.build
    @company.emails.build
    @category = Category.find(params[:category_id])
    @company.category_id = params[:category_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end
  
  def create
    @company = Company.new(params[:company])
    @company.category_id = params[:category_id]
    
    respond_to do |format|
      if @company.save
        flash[:notice] = 'Компания была создана и будет доступна после одобрения изменений админстратором.'
        format.html { redirect_to categories_url }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @company = Company.find(params[:id])
  end
  
  def update
    @company = Company.find(params[:id])
    @company.dump_attributes
    params[:company][:pending] = true
    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Компания была изменена и будет доступна после одобрения изменений админстратором.'
        format.html { redirect_to categories_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
