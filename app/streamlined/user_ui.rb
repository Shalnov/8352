module UserAdditions

end
User.class_eval { include UserAdditions }

Streamlined.ui_for(User) do
  user_columns :login, 
  { :link_to=>{ :action=>'edit'}},
  :email, :roles

  edit_columns :login, :email, :roles, :crypted_password
end   
