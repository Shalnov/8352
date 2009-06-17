class Admin::TagsController < Admin::ApplicationController

  active_scaffold :tags do |config|
    show.link.label     = 'Показать'
    update.link.label   = 'Изменить'
    delete.link.label   = 'Удалить'
    create.link.label   = 'Создать'
    search.link.label   = 'Поиск'
          
    config.label = "Тэги"
    config.columns[:name].label           = 'тэг'
    config.columns[:taggings_count].label = 'счетчик'
    config.columns[:taggings].label       = 'объекты'

    config.columns = [:name, :taggings_count]
    config.update.columns.exclude :taggings_count, :taggings
  end
  
end
