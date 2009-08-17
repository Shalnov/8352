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

end
