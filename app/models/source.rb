# -*- coding: utf-8 -*-
class Source < ActiveRecord::Base
  has_many :links
  has_many :results #, :through => :links
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
      if cat[:id] && !cat[:id].blank?
        ResultCategory.create!(:category_id=>cat[:id],
                               :category_name=>cat[:title],
                               :source_id=>self.id)
      end
    end
  end

  def export_to_catalog
    #   logger = Logger.new("#{RAILS_ROOT}/log/importer.log")
    results = Result.importable(self.id)
    updated_companies_count=0
    new_companies_count=0
    
    results.map { |res|
      
      if company = res.company || Company.find_by_result(res)

        company.import_result(res)
        updated_companies_count+=1
        
      else
        
        Company.create_from_result(res)
        new_companies_count+=1
        
      end
      
      res.is_updated = false
      res.save
    }
    
    {:updated=>updated_companies_count,
      :new=>new_companies_count,
      :all=>new_companies_count+updated_companies_count
    }
  end
    
  
  
  def unprocessed_categories
    Result.find_by_sql(["select category, count(*) from results left join result_categories on category=category_name where is_updated and category_id IS NULL and results.source_id=? group by category",
                        self.id]).
      map{|r| r.category}.compact.sort
  end


end

