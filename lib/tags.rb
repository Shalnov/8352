
# module ActiveRecord
#   module Acts #:nodoc:
#     module List #:nodoc:
#       def self.included(base)
#         base.extend(ClassMethods)
#       end

# p "Tag.class_eval"
Tag.class_eval do
  unloadable
  has_many :tags_synonyms
end

# module Tag
#   def self.included(base)
#     base.extend(ClassMethods)
#   end
#     module ClassMethods
#       has_many :tags_synonyms
#     end
# end

