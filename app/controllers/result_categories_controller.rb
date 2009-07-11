class ResultCategoriesController < ApplicationController

  def index
    @update_categories_count = Category.update_count
    @update_records_count = Result.records_for_import.size
  end
  
  def import_categories
    categories_results = Import::Category.run
    @categories = ResultCategory.uniq_unprocessed_categories
  end
  
  def update_categories
    if params[:categories]
      params[:categories].each_value do |cat|
        if cat[:id] && !cat[:id].blank?
          ResultCategory.update_all("category_id = #{cat[:id]}", { :category_name => cat[:title] })
        end
      end
    end
    redirect_to :action => :index
  end
  
  def import_results
    Import::Importer.run
    redirect_to :action => :index
  end
end
