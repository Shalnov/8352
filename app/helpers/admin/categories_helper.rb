module Admin::CategoriesHelper

  def parent_form_column(record, input_name)
    select :record, :parent_id, Category.find(:all).collect{|c| [c.name, c.id]}, { :include_blank => true }, { :name => input_name }
  end
end