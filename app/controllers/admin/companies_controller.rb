class Admin::CompaniesController < ApplicationController
  
  layout 'admin'
  
  active_scaffold :companies do |config|
    show.link.label     = 'Показать'
    update.link.label   = 'Изменить'
    delete.link.label   = 'Удалить'
    create.link.label   = 'Создать'
    search.link.label   = 'Поиск'
          
    config.label = "Компании"
    config.columns[:category].label     = 'категория'
    config.columns[:pending].label      = 'на модерации'
    config.columns[:name].label         = 'название'
    config.columns[:full_name].label    = 'полное название'
    config.columns[:inn].label          = 'ИНН'
    config.columns[:address].label      = 'адрес'
    config.columns[:site].label         = 'сайт'
    config.columns[:phones].label       = 'телефоны'
    config.columns[:emails].label       = 'e-mail'
    config.columns[:director].label     = 'руководитель'
    config.columns[:description].label  = 'описание'
    config.columns[:working_time].label = 'рабочее время'
    config.columns[:sources].label      = 'источники'
    config.columns[:updated_at].label   = 'изменена'

    config.columns = [:category, :pending, :name, :full_name, :inn, :address, :site, :director, :description, :working_time, :sources, :updated_at, :phones, :emails]
    config.list.columns.exclude :director, :description, :working_time, :sources
    config.update.columns.exclude :updated_at
    
    config.list.sorting = { :updated_at => :desc }
  end

  def conditions_for_collection
    ["pending = 't' or pending = 'f'"]
  end

  def before_create_save(record)
    record.pending = false
  end
  
  def find_if_allowed(id, action, klass = nil)
    klass ||= active_scaffold_config.model
    record = klass.find_by_id(id, :conditions => { :pending => true })
    raise ActiveScaffold::RecordNotAllowed unless record.authorized_for?(:action => action.to_sym)
    return record
  end
  
end
