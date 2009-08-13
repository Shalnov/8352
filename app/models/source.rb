# -*- coding: utf-8 -*-
class Source < ActiveRecord::Base

  self.establish_connection :grabber
  
  has_many :results

  has_many :ad_results

#  has_many :companies, :through => :results
  has_many :result_categories

  
#  has_many :jobs

  after_create :update_from_grabber_module
  
  def update_from_grabber_module
    require "Grabber::#{self.grabber_module}".underscore
    grabber = "Grabber::#{self.grabber_module}".constantize.new
    self.update_attributes :target_url => grabber.target_url,
                           :description => grabber.target_description
  end

  def set_categories(cats)

    cats.each_value do |cat|
            
      if cat[:id]=="all"
        raise "Not implemented"
        # # TODO поискать уже в результатах
        # category=Category.find_or_create_from_string(cat[:title])
        # ResultCategory.create!(:category_id=>category.id,
        #                        :category_name=>cat[:title],
        #                        :source_id=>self.id)
      elsif cat[:id].blank? || cat[:id]==""
        # ничего не устанавливаем
      elsif cat[:id].to_i>0
        ResultCategory.create!(:category_id=>cat[:id],
                               :category_name=>cat[:title],
                               :source_id=>self.id)

      else
        raise "Error! Bad category id selected: #{cat[:id]}"
      end
    end
  end
  

  def import_results

    #   logger = Logger.new("#{RAILS_ROOT}/log/importer.log")
      
    results = Result.importable(self.id)
    
    updated_companies_count=0
    new_companies_count=0
    
    results.andand.each { |res| 
      res.import
#       p res
#       raise "raise"
      if res.fine? 
        new_companies_count+=1
      elsif res.partly?
        updated_companies_count+=1
      end
    }
    
    {:updated=>updated_companies_count,
      :new=>new_companies_count,
      :all=>new_companies_count+updated_companies_count
    }
  end
  
  def unprocessed_categories
#    Result.find_by_sql(["select results.category_name, count(*) as count from results left join result_categories on result_categories.category_name=results.category_name where state='updated' and category_id IS NULL and results.source_id=? group by results.category_name",
    Result.find_by_sql(["select results.category_name, count(*) as count from results  where state='updated'  and results.source_id=? and category_name is not null and category_name not in (select category_name from result_categories where source_id=?) group by results.category_name",
                        self.id, self.id]).
      sort { |x,y| x.category_name<=>y.category_name }
  end


end

