require 'logger'

module Import
  class Category
    def self.run
      logger = Logger.new("#{RAILS_ROOT}/log/importer.log")
      # inspect all updated results records for result_categories joins
      results = Result.find(:all, :conditions => { :is_updated => true })
      results.each do |res|
        if res.result_category.nil?
          # find previously linked categories
          rc = ResultCategory.find(:first, :conditions => { :category_name => res.category })
          if rc && rc.category
            ResultCategory.create({ :category_name => res.category, 
                                    :result_id => res.id, 
                                    :category_id => rc.category_id })
          else
            ResultCategory.create({:category_name => res.category, :result_id => res.id, :category_id => nil})
          end
        elsif res.result_category.category.nil?
          # find previously linked categories for existing records
          rc = ResultCategory.find(:first, :conditions => ["category_name = :category_name AND category_id IS NOT NULL", 
                                                          { :category_name => res.category }])
          if rc
            res.result_category.update_attribute(:category_id, rc.category_id)
          end
        end
      end
      ResultCategory.find(:all, :conditions => ["category_id IS NULL"])
    end
  end
end
