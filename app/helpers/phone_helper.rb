# -*- coding: utf-8 -*-
module PhoneHelper
  
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
  
  # 1. Убирает из номера все символы кроме цифр
  
  # 2. Приводит номер к федеральному значению в соответсвии 
  # с таблицей смены номера и замарочками мобильных операторов
    
  def normalize_phone(phone)
    
    # убрать все знаки кроме цифр
    phone=phone.gsub(/[^0-9]/,'')
    
    @current_prefix="78352"
    
    if phone.size==11
      phone[0]="7"
    elsif phone.size==10
      phone="7"+phone
    elsif phone.size==6
      phone=@current_prefix+phone
    else
      raise 
    end
    
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