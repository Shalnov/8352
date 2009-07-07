require 'logger'

module Grabber
  class Importer
    def self.run
      while (res = Result.next_for_import)
        if res.company_id
          # update attributes for existing company
          company = Company.find_by_id(res.company_id)
          if company
            # company found
            company.update_attributes_from_result(res)
            company.save
            res.is_updated = false
          else
            # mark result as removed
            res.is_removed = true
          end
          res.save
        else
          company = Company.new
          # find by phone
          if company = get_company_by_phones(res.phones)
            if company.name == res.name
              # update attributes
              company.update_attributes_from_result(res)
            else
              # store attributes and mark 'Need moderation'
              company.store_attributes_from_result(res)
              company.need_human = true
            end
          else
            # search by name
            if c = Company.find_by_name(res.name)
              # update
              company = c
              company.update_attributes_from_result(res)
            else
              # add new record
              company.update_attributes_from_result(res)
              company.is_new = true
            end
          end
          company.save
          res.company_id = company.id
        end
        res.is_updated = false
        res.save
      end
    end
    
    def self.get_company_by_phones(phones)
      phones.split(',').each do |phone|
        formated_phone = clear_phone_number(phone)
        return p.company if formated_phone && formated_phone != 0 && p = Phone.find_by_number(formated_phone)
      end
    end
    
    def self.clear_phone_number(number)
      number.to_s.gsub(/([^0-9])/, '').to_i
    end
  end
end
