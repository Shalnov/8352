class TelefonFederal < ActiveRecord::Base

  def self.federal_number(phone_number)
    numbers = self.find_by_sql(["select federal || substr(?,length(city)+1,12) as federal from telefon_federals where substr(?,1,length(city))=city", phone_number, phone_number])
    numbers.first.federal unless numbers.empty?
  end

end
