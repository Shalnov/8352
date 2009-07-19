# -*- coding: utf-8 -*-
module PhoneHelper
  extend ActiveSupport::Memoizable
  
  def phone_code(type)
    type == true ? "3 знака" : "5 знаков"
  end
  
  def h_phone(phone)
    
    # Может сделать вывод также в городском формате?
    
    if phone.number < 79*10**9
      str = phone.number.to_s
      h "7 (#{str[1..4]}) #{str[5..6]}-#{str[7..8]}-#{str[9..10]}"
    else
      str = phone.number.to_s
      h "7 (#{str[1..3]}) #{str[4..6]}-#{str[7..8]}-#{str[9..10]}"
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

#    phone = TelefonRename.renamed_number(phone) || phone
#    TelefonFederal.federal_number(phone) || phone

    renames=TelefonRename.
      find_by_sql ["select  newphone || substr(?,length(oldphone)+1,12) as newnumber from telefon_renames where substr(?,1,length(oldphone))=oldphone",
                  phone,phone]
    phone = renames[0].newnumber if renames.size>0

    federals=TelefonFederal.
      find_by_sql ["select  federal || substr(?,length(city)+1,12) as federal from telefon_federals where substr(?,1,length(city))=city",
                  phone,phone]
    phone = federals[0].federal if federals.size>0

    phone
  end

  
end
