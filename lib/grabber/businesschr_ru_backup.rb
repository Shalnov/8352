module Grabber
  class BusinesschrRu < Grabber::Base

    require 'open-uri'
    require 'nokogiri'
    require 'logger'
    require 'mechanize'

    attr_reader :target_url, :description

    def initialize
      super
      @target_url = 'http://businesschr.ru/'
      @description = 'businesschr site'
    end

    def level_1(link) # get main catalog
      uri = URI.parse(link.url)
      Nokogiri::HTML(uri.open.read).search('html/body/table/tr[4]/td[1]/table/tr[1]/td[1]/table//a').each do |tag_a|
        if tag_a['href'] =~ /^\?do=catalog\&cat=\d+$/
          child_link = link.children.find_or_create_by_url_and_source_id_and_name "#{uri.scheme}://#{uri.host}#{':' + uri.port.to_s if uri.port != 80}/#{tag_a['href']}", link.source_id, tag_a.content
          yield child_link if child_link.is_follow
        end
      end
    end

    def level_2(link) # get subcatalog
      uri = URI.parse(link.url)
      Nokogiri::HTML(uri.open.read).search('/html/body/table/tr[4]/td/table/tr/td[2]/table/tr[3]/td/table[2]//a').each do |tag_a|
        if tag_a['href'] =~ /^\?do=catalog\&cat=\d+$/
          child_link = link.children.find_or_create_by_url_and_source_id_and_name "#{uri.scheme}://#{uri.host}#{':' + uri.port.to_s if uri.port != 80}/#{tag_a['href']}", link.source_id, tag_a.content
          yield child_link if child_link.is_follow
        end
      end
    end

    def level_3(link) # get link to page info
      uri = URI.parse(link.url)
      first_page_body = uri.open.read
      links_to_next_pages = Nokogiri::HTML(first_page_body).search('//a[@class="list"]').map { |tag_a| tag_a['href'] }
      links_to_next_pages.shift # drop link to 1th page (1th page is downloaded to first_page_body variable)
      ([first_page_body] + links_to_next_pages).each_with_index do |element, index|
        Nokogiri::HTML(index.zero? ? element : open(element).read).search('/html/body/table/tr[4]/td/table/tr/td[2]/table/tr[3]//a').each do |tag_a|
          if tag_a.content.include?('Подробнее >>')
            child_link = link.children.find_or_create_by_url_and_source_id "#{uri.scheme}://#{uri.host}#{':' + uri.port.to_s if uri.port != 80}/#{tag_a['href']}", link.source_id
            yield child_link if child_link.is_follow
          end
        end
      end
    end

    def level_info(link) # grab page info

      attributes = { :raw_html => Nokogiri::HTML(open(link.url).read).search('/html/body/table/tr[4]/td/table/tr/td[2]/table/tr[3]/td/table[4]').first.to_s }

      Nokogiri::HTML(attributes[:raw_html]).search('//td').each do |tag_td|
        td = tag_td.content
        if td.include?('Название:') && !attributes.include?(:name)
          attributes.merge! :name => td.sub('Название:','').strip

        elsif td.include?('Адрес:') && !attributes.include?(:address)
          attributes.merge! :address => td.sub('Адрес:','').strip

        elsif td.include?('Телефон:') && !attributes.include?(:phones)
          attributes.merge! :phones => td.sub('Телефон:','').strip

        elsif td.include?('Раздел:') && !attributes.include?(:category)
          attributes.merge! :category => td.sub('Раздел:','').strip

        elsif td.include?('E-mail:') && !attributes.include?(:email)
          attributes.merge! :email => td.sub('E-mail:','').strip

        else
          if attributes.include?(:other_info)
            attributes[:other_info] += td.strip
          else
            attributes.merge! :other_info => td.strip
          end
        end
      end
      attributes
    end

    def run
#      progress = 0
#      record_progress(progress)

      source = Source.find_by_grabber_module(self.class.to_s.split('::').last)
      source.links.create :url => @target_url if source.links.root.nil?
      source.results.each {|r| r.update_attributes :is_checked => false, :is_updated => false }

      level_1(source.links.root) do |link_level_1|
            level_2(link_level_1) do |link_level_2|
                  level_3(link_level_2) do |link_level_3|
                        update_results(link_level_3, level_info(link_level_3))
#                        progress += 1
#                        record_progress(progress)
                  end if link_level_2.is_follow
            end if link_level_1.is_follow
      end
    end

    def update_results(grab_link, grab_result)
      # grab_result is Array(many companies per page) or Hash (one company per page)
      if grab_result.is_a?(Array)
        grab_result.each{|result_hash| update_results(grab_link, result_hash) }
      else
          stored_results = grab_link.source.results.not_checked.find :all, :conditions => { :name       => grab_result[:name],
                                                                                            :address    => grab_result[:address],
                                                                                            :phones     => grab_result[:phones],
                                                                                            :email      => grab_result[:email],
                                                                                            :site_url   => grab_result[:site_url],
                                                                                            :category   => grab_result[:category],
                                                                                            :work_time  => grab_result[:work_time],
                                                                                            :other_info => grab_result[:other_info] }

          if stored_results.empty?
            # или новая или измененная
            stored_results = grab_link.source.results.not_checked.find_all_by_name_and_address(grab_result[:name], grab_result[:address])
            if stored_results.empty?
              # новая
              grab_link.results.create grab_result.merge!({ :is_checked => true, :is_updated => true })
            else
              # измененная
              stored_results.first.update_attributes(grab_result.merge!({ :is_checked => true, :is_updated => true }))
            end
          else
            # присутствует и не менялась
            stored_results.first.update_attributes :is_checked => true, :is_updated => false
          end

    #------------------------------
    end
    end

  end

#  def record_progress(progress)
#
#  end

end

