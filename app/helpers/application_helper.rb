# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def render_category_with_all_childs(category)
    res = "<li>"
    res += h category.name
    if category.children.size > 0
      res += "<ul>"
      category.children.each do |child|
        res += render_category_with_all_childs(child)
      end
      res += "</ul>"
    end
    res += "</li>"
    res
  end
end
