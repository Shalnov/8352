# -*- coding: utf-8 -*-
class CompanyGroupsController < ApplicationController

  def index
    # @companies = params[:category_id] ? 
    # Company.find_all_by_category_id(params[:category_id]) : 
    #   Company.find(:all,:limit=>50)

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render :xml => @companies }
    # end
  end

  def show
    @company_group = CompanyGroup.find params[:id]
    @companies = @company_group.companies.paginate :page => params[:page], :per_page => configatron.companies_per_page
  end
  
  # def search
  #   @tags = Tag.search(params[:search])
  #   @categories = Category.search("*#{params[:search]}*")
  #   @companies = Company.search("*#{params[:search]}*")
  #   render :layout => false
  # end  
end
