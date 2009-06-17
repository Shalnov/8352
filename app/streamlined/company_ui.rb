# -*- coding: utf-8 -*-
module CompanyAdditions

end
Company.class_eval { include CompanyAdditions }

Streamlined.ui_for(Company) do
  user_columns :name, 
  { :human_name=>'Название',
    :link_to=>{ :action=>'edit'}},
  :address, :category, :tags, 
  :phones
  edit_columns :name, :full_name, :address, :inn, :category, :tags, :phones
end   
