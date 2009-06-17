# -*- coding: utf-8 -*-
module Admin::ApplicationHelper
  def streamlined_top_menus
    [
     ["Компании", { :controller=> 'companies'}],
     ["Федеральные номера", { :controller=> 'telefon_federals'}],
     ["Смена номера", { :controller=> 'telefon_renames'}],
     ["Пользователи", { :controller=> 'users'}],
     ["Категории", { :controller=> 'categories'}],
     ["Тэги", { :controller=> 'tags'}],
     ["Jobs", { :controller=> 'jobs'}],
     ["Storages", { :controller=> 'storages'}],
    ]
  end
  
    
  def streamlined_branding
    link_to "8352.info/admin", "/admin/"
  end

  def streamlined_footer
    ""
  end
  
 def streamlined_side_menus
    [ ["List All Coffee", {:controller => "coffees", :action => "list"}] ]
  end

end
