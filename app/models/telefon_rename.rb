class TelefonRename < ActiveRecord::Base

  def self.renamed_number(phone_number)
    numbers = self.find_by_sql(["select newphone || substr(?,length(oldphone)+1,12) as newnumber from telefon_renames where substr(?,1,length(oldphone))=oldphone", phone_number, phone_number])
    numbers.first.newnumber unless numbers.empty?
  end

end
