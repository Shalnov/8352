# -*- coding: utf-8 -*-
class Admin::UsersController < Admin::ApplicationController

  layout 'streamlined'
  acts_as_streamlined

#   before_filter :admin_filter

#   active_scaffold :users do |config|
#     show.link.label     = 'Показать'
#     update.link.label   = 'Изменить'
#     delete.link.label   = 'Удалить'
#     create.link.label   = 'Создать'
#     search.link.label   = 'Поиск'
          
#     config.actions.exclude :create, :delete

#     config.label = "Пользователи"
#     config.columns[:email].label        = 'e-mail'
#     config.columns[:login].label        = 'логин'
#     config.columns[:name].label         = 'имя'
#     config.columns[:roles].label        = 'роли'
#     config.columns[:created_at].label   = 'зарегистрирован'

#     config.columns = [:email, :login, :name, :roles, :created_at]
#   end
  
# private  
#   def admin_filter
#     access_denied if !has_role?("admin")
#   end
end
