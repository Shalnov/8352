# -*- coding: utf-8 -*-
class Admin::CategoriesController < Admin::ApplicationController
  layout 'streamlined'
  acts_as_streamlined

  
#   active_scaffold :categories do |config|
#     show.link.label     = 'Показать'
#     update.link.label   = 'Изменить'
#     delete.link.label   = 'Удалить'
#     create.link.label   = 'Создать'
#     search.link.label   = 'Поиск'
          
#     config.label = "Категории"
#     config.columns[:name].label             = 'категория'
#     config.columns[:description].label      = 'описание'
#     config.columns[:position].label         = 'позиция'
#     config.columns[:parent].label           = 'родительская категория'
#     config.columns[:companies_count].label  = 'кол-во компаний'

#     config.columns = [:name, :description, :position, :parent, :companies, :companies_count]
    
#     config.columns[:parent].actions_for_association_links = []
#     # config.columns[:parent].collapsed = true

#     config.list.columns.exclude :companies
#     config.create.columns.exclude :companies, :companies_count
#     config.update.columns.exclude :companies, :companies_count
    
#     config.nested.add_link("Компании", [:companies])

#   end
  
end
