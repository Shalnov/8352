class Admin::TaggingsController < ApplicationController

  layout 'admin'
  
  active_scaffold :taggings do |config|
    show.link.label     = 'Показать'
    update.link.label   = 'Изменить'
    delete.link.label   = 'Удалить'
    create.link.label   = 'Создать'
    search.link.label   = 'Поиск'
          
    config.label = "Объекты тэгов"
    config.columns[:taggable].label       = 'объект'

    config.columns = [:taggable]
  end
  
end