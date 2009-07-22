# -*- coding: utf-8 -*-
module PhoneHelper
  extend ActiveSupport::Memoizable
  
  
  def h_phone(phone)
    return '' unless phone    
    # Может сделать вывод также в городском формате?
    #str = phone.number.to_s
    str = phone.to_s
    if str=~/^79/
      h "7 (#{str[1..3]}) #{str[4..6]}-#{str[7..8]}-#{str[9..10]}"
    else
      h "7 (#{str[1..4]}) #{str[5..6]}-#{str[7..8]}-#{str[9..10]}"
    end
  end

  def h_phone_city(phone)
    
    # Может сделать вывод также в городском формате?
    #str = phone.number.to_s
    str = phone.to_s
    if str=~/^79/
      h "7 (#{str[1..3]}) #{str[4..6]}-#{str[7..8]}-#{str[9..10]}"
    else
      h "7 (#{str[1..4]}) #{str[5..6]}-#{str[7..8]}-#{str[9..10]}"
    end
  end

  
  # Достает из строки номер, и его обозначение
  def parse_phone(str,city=nil)
    return if str.blank?
    
    str=str.to_s.strip
#    pat=/([0-9\-]+)\s*(.*)/
    
    h={
      :number=>nil,
      :is_fax=>false,
      :department=>nil
    }
    number = str.gsub(/[^0-9]+$/,'').gsub(/^[^0-9]+/,'')
#    p number
    h[:number] = normalize_phone(number,city) || return
    # TODO сделать обработку ошибоку raise("ERROR: Can't recognize phone number from string '#{str}'")
    
    department = str.gsub(/[0-9\-\ \(\)+]+$/,'').gsub(/^[0-9\-\ \(\)+]+/,'');
#    p department
    if department=~/факс/
      h[:is_fax]=true
    else
      h[:department]=department
    end
  
    h
  end
  

  def get_current_city
    City.find_by_name("Чебоксары")
  end

  memoize :get_current_city
  
  # 1. Убирает из номера все символы кроме цифр
  
  # 2. Приводит номер к федеральному значению в соответсвии 
  # с таблицей смены номера и замарочками мобильных операторов
    
  def normalize_phone(phone,city=nil)
    city=get_current_city unless city
    return nil if phone.blank?
    
    phone_old=phone
    phone=phone.to_s.gsub(/[^0-9]/,'')
    
    if phone.size==11
      phone[0]="7"
    elsif phone.size==10
      phone="7"+phone
    elsif phone.size+city.prefix.size==11 # 6+5 или 5+6 TOFIX некоторые имеют больше, например http://dapi.orionet.ru:3000/admin/results/edit/62691
      phone=city.prefix+phone
      # TODO Писать в лог
    else
      p "PhoneHelper::normalize_phone error - bad phone number '#{phone_old}/#{phone}'"
      return phone
    end

    phone = TelefonRename.rename_number(phone)
    TelefonFederal.federal_number(phone)

  end

  
end
