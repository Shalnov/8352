# -*- coding: utf-8 -*-
require 'singleton'
require 'unicode'

class PhoneParser
  include Singleton

  # Выделяет телефоны из строки. Возвращает массив хешей [{ :phone => "телефон", :is_fax => true/false}]
  # Работает так:
  #   - В строке ищуся все потенциальные телефоны. Правила поиска описаны ниже, в комментарии к PHONE_EXTRACT_REGEXP.
  #   - Каждый найденный телефон прогоняется через список исключений (EXTRACT_PHONE_CONDITIONS), и отметается если сработало
  #     хотя бы одно исключение.
  #   - Проверяется, нашли мы факс или простой телефон, см. комментарии к is_fax?
  def parse(line)  
    cutting_line = line.dup
    
    # Выделяем потенциальные телефоны из строки. Unicode::downcase нужен потому что модифаер /i
    # раби регеэкспа несовместим с юникодом.
    parsed = line.scan(PHONE_EXTRACT_REGEXP).map do |m|
      phone = m[0]   
      is_phone = EXTRACTED_PHONE_CONDITIONS.map { |c| c.call(phone.dup) }.any?
      if is_phone
        cutting_line, is_fax = is_fax?(cutting_line, phone)
        { :number => phone, :is_fax => is_fax }
      end
    end
    parsed.compact
  end

protected
  # Проверяет, факс это или нет.
  # Для этого, в строке до телефона ищется слово "факс".
  # Сюда можно добавить проверку расстояния между словом "факс" и, собственно, телефоном.
  def is_fax?(line, phone)
    phone_index = line.index(phone)
    fax_slice = Unicode::downcase(line[0, phone_index])
    line = line[phone_index..-1]
    is_fax = !(fax_slice =~ FAX_REGEXP).nil?    
    [line, is_fax]
  end

  # Регулярное выражение для выделения телефона. Означает следующее:
  #   - До телефона может быть всё что угодно или пробел.
  #   - Телефон начинается с цифры, +, (
  #   - Телефон оканчивается на цифру.
  #   - Телефон не может содержать буквы, но может - цифры, пробелы, скобки, тире.
  #   - Перед телефоном может идти факс.
  #   - Между факсом и телефоном не должно быть ворд-символов.
  PHONE_EXTRACT_REGEXP = /([\d\(\+]{1}[\d\-\(\)\s]+\d{1})[\b|\w]*/ui
  
  # Регулярное выражение для выделения факса.
  FAX_REGEXP = /(ф.|факс|fax)/ui
  
  # Условия, по которым проверяется телефон после выделения.
  # Сюда будем добавлять условия, которые найдём.
  EXTRACTED_PHONE_CONDITIONS = [
    # Длина телефона - от 5 до 13 цифр без знаков ()-+
    lambda { |phone| (5..13).member? phone.gsub(/[\-\s\(\)\s+]/, '').length }    
  ]
end