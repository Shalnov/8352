# -*- coding: utf-8 -*-
Tag.class_eval do
  unloadable
  has_many :synonyms, :class_name=>"TagsSynonym"

  class << self
    def tags_condition(tags, table_name = Tag.table_name)
      condition = tags.map { |t| sanitize_sql(["ttt.tag_id=?", t.id]) }.join(" OR ")
      "(" + condition + ")"
    end
    
    private :tags_condition
    
    def tags_no_condition(tags, table_name = Tag.table_name)
      condition = tags.map { |t| sanitize_sql(["id!=?", t.id]) }.join(" AND ")
      "(" + condition + ")"
    end
    
    private :tags_no_condition
    
    def find_nested_tags(tags,taggable_type=nil)
      conditions=[tags_no_condition(tags)]
      type_cond=taggable_type==nil ? '' : " #{Tagging.table_name}.taggable_type = #{quote_value(taggable_type.name)} AND "
      conditions << <<-END
                 id in (
                 select tag_id from #{Tagging.table_name} where tags.id=taggings.tag_id and #{type_cond} 
                 ( SELECT COUNT(*) FROM #{Tagging.table_name} ttt
                 WHERE ttt.taggable_id=#{Tagging.table_name}.taggable_id AND #{tags_condition(tags)}) = #{tags.size} )
              END
      options =           
        { 
      :select => "DISTINCT #{table_name}.*",
        :joins => "",
        :conditions => conditions.join(" AND ")
      }
      
      find(:all,options)
    end
    
  end
  


  
  def nested_tags
    nested = []
    taggings.map { |t| nested = nested + t.taggable.tag_list }
    nested.uniq
  end

end

Tagging.class_eval do
  unloadable

  # Ссылки на тэги у этого taggable

#  has_many :taggables, :foreign_key=>"taggable_id", :primary_key=>"taggable_id", :class_name=>"Tagging"
  
#  has_many :taggs, :foreign_key=>"taggable_id", :primary_key=>"taggable_id2", :class_name=>"Tagging"
#  has_many :nested_tags, :through=>:taggs, :source=>:tag
#   has_many :tags, :finder_sql=>
#     "SELECT DISTINCT tags.*
# FROM tags LEFT JOIN tagging ON tag.id=taggings.tag_id
# WHERE taggings.taggable_id=#{taggable_id}"

 #, :through=>:taggables
  
  
  # Тэги, которые также есть у компаний, имеющий такой тэг
  
  
#   def nested_tags
#     nested=[]
#     taggings.map{ |t| }
#   end
end

