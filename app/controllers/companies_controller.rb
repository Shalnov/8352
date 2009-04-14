class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.find(:all)
    @companies = Company.find_all_by_category_id(params[:category_id]) if params[:category_id]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end
  
  # GET /companies/new
  # GET /companies/new.xml
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
  
  # POST /companies
  # POST /companies.xml
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
  
  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end
  
  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])
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
  
  def search
    @tags = Tag.search(params[:search])
    @categories = Category.search(params[:search])
    @companies = Company.search(params[:search])
    render :layout => false
  end  
end
