class Admin::EmailsController < ApplicationController
  
  layout 'admin'
  
  active_scaffold :emails do |config|
    show.link.label     = 'Показать'
    update.link.label   = 'Изменить'
    delete.link.label   = 'Удалить'
    create.link.label   = 'Создать'
    search.link.label   = 'Поиск'
          
    config.label = "E-mail"
    config.columns[:email].label          = 'e-mail'
    config.columns[:person].label         = 'сотрудник'
    config.columns[:department].label     = 'отдел'

    config.columns = [:email, :person, :department]
    config.list.columns.exclude :person, :department
  end

end
