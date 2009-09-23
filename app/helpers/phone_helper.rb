# -*- coding: utf-8 -*-
module PhoneHelper
#  extend ActiveSupport::Memoizable
  
  def h_phones(phones)
    phones.map{ |p| h_phone(p) }.join(', ')
  end
  
  def h_phone(phone)
    return '' unless phone    
    str = phone.to_s
    if str=~/^79/
      "7 (#{str[1..3]}) #{str[4..6]}-#{str[7..8]}-#{str[9..10]}"
    else
      # TOFIX сделать нормально
      if str[1..4]=="8352"
        "#{str[5..6]}-#{str[7..8]}-#{str[9..10]}"
      else
      "7 (#{str[1..4]}) #{str[5..6]}-#{str[7..8]}-#{str[9..10]}"
      end
    end
  end    

end
