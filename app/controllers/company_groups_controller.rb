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

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company_group = CompanyGroup.find(params[:id])
    @companies=@company_group.companies
  end
  
  # def search
  #   @tags = Tag.search(params[:search])
  #   @categories = Category.search("*#{params[:search]}*")
  #   @companies = Company.search("*#{params[:search]}*")
  #   render :layout => false
  # end  
end
