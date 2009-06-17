class Admin::PhonesController < Admin::ApplicationController
  
  active_scaffold :phones do |config|
    show.link.label     = 'Показать'
    update.link.label   = 'Изменить'
    delete.link.label   = 'Удалить'
    create.link.label   = 'Создать'
    search.link.label   = 'Поиск'
          
    config.label = "Телефоны"
    config.columns[:number].label         = 'номер'
    config.columns[:person].label         = 'сотрудник'
    config.columns[:department].label     = 'отдел'
    config.columns[:working_time].label   = 'рабочее время'
    config.columns[:description].label    = 'описание'
    config.columns[:short_code].label     = '3-значный код'

    config.columns = [:number, :person, :department, :working_time, :description]
    config.list.columns.exclude :person, :department, :working_time, :description
  end
  
  def before_create_save(record)
    record.short_code = false
  end
  
end
