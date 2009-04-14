module ApplicationHelper
  include ActsAsTaggable::TagsHelper
  
  def render_category_with_all_childs(category, category_func, admin=false, description=false)
    res = "<li>"
    res += category_func.call(category)
    res += " " + link_to('Изменить', edit_admin_category_path(category)) if admin
    res += " | " + link_to('Удалить', admin_category_path(category), :confirm => 'Удалить категорию?', :method => :delete) if admin
    res += "<br />" + h(category.description) if description
    if category.children.size > 0
      res += "<ul>"
      category.children.each do |child|
        res += render_category_with_all_childs(child, category_func, admin, description)
      end
      res += "</ul>"
    end
    res += "</li>"
    res
  end
  
  def render_categories_front_end(category, admin=false, description=false)
    render_category_with_all_childs(category, lambda { |category| link_to category.name, category_url(category) }, admin, description)
  end
  
  def phone_code(type)
    type == true ? "3 знака" : "5 знаков"
  end
  
  def yes_no(var)
    var == true ? "да" : "нет"
  end
end
