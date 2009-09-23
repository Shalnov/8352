class SearchesController < ApplicationController

  def show
    # TODO sanitize query !!!!!!!!!!!!
    @search_query = params[:q]
    unless @search_query.blank?
      companies = Company.search "*#{@search_query}*", :limit => 1000
      @companies_size = companies.size # общее кол-во вроде бы можно брать у will_paginate, надо см. документацию
      @companies = companies.paginate :page => params[:page], :per_page => configatron.companies_per_page
    end
  end

  def create
    redirect_to search_path :q => params[:q]
  end

end
