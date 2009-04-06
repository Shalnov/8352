# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def render_category_with_all_childs(category, admin=false, description=false)
    res = "<li>"
    res += h category.name
    res += " " + link_to('Изменить', edit_category_path(category)) if admin
    res += " | " + link_to('Удалить', category, :confirm => 'Удалить категорию?', :method => :delete) if admin
    res += "<br />" + h(category.description) if description
    if category.children.size > 0
      res += "<ul>"
      category.children.each do |child|
        res += render_category_with_all_childs(child, admin, description)
      end
      res += "</ul>"
    end
    res += "</li>"
    res
  end
end
