require 'logger'

module Import
  class Importer
    def self.run
      logger = Logger.new("#{RAILS_ROOT}/log/importer.log")
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
          if c = get_company_by_phones(res.phones)
            company = c
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
              company.full_name = res.name
            end
          end
          logger.error "[#{Time.now.to_s}] Errors in grabbed company: #{company.errors.full_messages.inspect}" unless company.save
          res.company_id = company.id
        end
        res.is_updated = false
        res.save
      end
    end
    
    def self.get_company_by_phones(phones)
      c = nil
      if phones
        phones.split(',').each do |phone|
          formated_phone = Phone.strip_non_digit(phone).to_i
          c = p.company if formated_phone && formated_phone != 0 && p = Phone.find_by_number(formated_phone)
          break
        end
      end
      c
    end
    
  end
end
