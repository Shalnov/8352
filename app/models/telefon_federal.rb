# -*- coding: utf-8 -*-
class TelefonFederal < ActiveRecord::Base

  def self.federal_number(phone)
    federals=TelefonFederal.
      find_by_sql ["select  federal || substr(?,length(city)+1,12) as federal from telefon_federals where substr(?,1,length(city))=city",
                  phone,phone]
    return federals.size>0 ? federals[0].federal : phone
  end
  
  def self.operator
    ['Мобайл','смартс','мегафон','Билайн','МТС']
  end

end
