# -*- coding: utf-8 -*-
module PhoneHelper
#  extend ActiveSupport::Memoizable
  
  def h_phone(phone)
    return '' unless phone    
    str = phone.to_s
    if str=~/^79/
      "7 (#{str[1..3]}) #{str[4..6]}-#{str[7..8]}-#{str[9..10]}"
    else
      "7 (#{str[1..4]}) #{str[5..6]}-#{str[7..8]}-#{str[9..10]}"
    end
  end

    
  
  # # Достает из строки номер, и его обозначение
  
  # def parse_phone(str,prefix=nil)
  #   return if str.blank?
    
  #   str=str.to_s.strip
    
  #   h={
  #     :number=>nil,
  #     :is_fax=>false,
  #     :department=>nil
  #   }
  #   number = str.gsub(/[^0-9]+$/,'').gsub(/^[^0-9]+/,'')

  #   h[:number] = normalize_phone(number,prefix) || return
    
  #   # TODO сделать обработку ошибоку raise("ERROR: Can't recognize phone number from string '#{str}'")
    
  #   department = str.gsub(/[0-9\-\ \(\)+]+$/,'').gsub(/^[0-9\-\ \(\)+]+/,'');

  #   if department=~/факс/
  #     h[:is_fax]=true
  #   else
  #     h[:department]=department
  #   end
  
  #   h
  # end
  


end
