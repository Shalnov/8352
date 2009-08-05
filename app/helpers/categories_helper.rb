# -*- coding: utf-8 -*-
module CategoriesHelper
  
  extend ActiveSupport::Memoizable
  
  def category_tree(roots)
    result = "<ul class='tree_root'>"
    roots.each { |root| result += _tree_category(root) }
    result += '</ul>'
  end
  memoize :category_tree
  
  def _tree_category(category)
    anchor = "aac_tree_#{category.id.to_s}"
    if category.ancestors_count == 0
      # CSS for root categories
      html_headline = ' class="tree_headline" ' 
      html_count = ''
    else
      # CSS for any deeper level of categories
      html_headline = '' 
      html_count = ' <span class="tree_count"> ' + h(category.companies_count.to_s)+ '</span>'
    end

    result = tag('a', {:name => anchor}) + tag('/a')
    result += "<li#{html_headline}>"
    result += '<b>' if @category == category.id

    result += link_to h(category.name),category_path(category)
#    result += link_to h(category.name), {:controller => 'category', :id => category.id }
    if category.ancestors_count > 0 and category.children.count == 0 then
#     result += h(category.name)
    elsif category.ancestors_count == 0 or category.children.count > 0 then
      result += '&nbsp;'
      result += content_tag('a', '[*]', :onclick => "new Element.toggle('#{anchor}'); return false",  :href => "\##{anchor}")
    else
#     result += link_to_unless_current h(category.name), {:controller => 'category', :id => category.id }# unless category.ancestors_count == 0
    end
#    result += '&nbsp;'
#    result += link_to 'компании', "/companies/?category_id=#{category.id}"
#    result += link_to 'компании', {:controller => 'category', :id => category.id }
    result += '</b>' if @category == category.id
    result += html_count # if !category.companies_count.blank? and category.companies_count > 0
    result += '</li>'

    if category.children.count > 0
      addon = (category.ancestors_count == 0 or category.descendants_ids.include?(@category) or (category.self_and_siblings_ids.include?(@category) and category.children_count == 0)) ? '' : ' style="display: none;"'
      result += "<ul id='#{anchor}' #{addon}>"
      category.children.each { |child| result += _tree_category(child) }
      result += '</ul>'
    end
    result
  end
  private :_tree_category

end
