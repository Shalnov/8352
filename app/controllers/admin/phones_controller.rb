class Admin::PhonesController < ApplicationController
  
  layout 'admin'
  
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

    config.columns = [:number, :person, :department, :working_time, :description, :short_code]
    config.list.columns.exclude :person, :department, :working_time, :description, :short_code
  end

end
