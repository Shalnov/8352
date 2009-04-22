class Admin::CategoriesController < ApplicationController
  
  layout 'admin'
  
  active_scaffold :categories do |config|
    show.link.label     = 'Показать'
    update.link.label   = 'Изменить'
    delete.link.label   = 'Удалить'
    create.link.label   = 'Создать'
    search.link.label   = 'Поиск'
          
    config.label = "Категории"
    config.columns[:name].label         = 'категория'
    config.columns[:description].label  = 'описание'
    config.columns[:position].label     = 'позиция'
    config.columns[:parent].label       = 'родительская категория'

    config.columns = [:name, :description, :position, :parent]
  end
end
