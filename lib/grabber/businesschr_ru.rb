module Grabber
  class BusinesschrRu < Grabber::Base

    require 'open-uri'
    require 'nokogiri'
    require 'logger'

    attr_reader :target, :target_url, :target_description, :level_methods

    def initialize
      super
      @target_url = 'http://businesschr.ru/'
      @target_description = 'businesschr.ru'
      @target = Source.find_by_grabber_module(self.class.to_s.split('::').last)
      @target.links.create :url => @target_url if @target.links.root.nil?
      @target.results.each {|r| r.update_attributes :is_checked => false, :is_updated => false }
      @level_methods = self.public_methods.select{|method| method =~ /^method_level_\d$/}.sort

      @logger = Logger.new("#{RAILS_ROOT}/log/grabber.log")
    end
    
#      progress = 0
#      record_progress(progress)
#   -----------------------------------------------------------------------
    def run
      link_collector(@target.links.root) do |link_to_page|
        update_results(link_to_page, grab_from_page(link_to_page)) #unless link_to_page.is_appeared
#@logger.info "start link_collector block !"
      end
    end
#   -----------------------------------------------------------------------
#    def link_collector link, &block
#@logger.info "link_collector: start"
##@level_methods.each{|ll| @logger.info "link_collector, methods:>#{ll}" }
#
#
#      method_level = @level_methods.shift
#      self.send(method_level.to_sym, link) do |next_level_link|
#        @logger.info "link_collector: in to next_level_link block"
#        if @level_methods.empty?
##          @logger.info "link_collector: yield next_level_link"
#          yield next_level_link #if block_given?
#        else
#
#          link_collector next_level_link, &block
#
#        end
##        @logger.info "link_collector: out from next_level_link block"
#      end
#      @level_methods.unshift method_level
#@logger.info "link_collector: end"
#    end
#   -----------------------------------------------------------------------
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
      end
    end
#   -----------------------------------------------------------------------
#   -----------------------------------------------------------------------
    def method_level_1(link)
@logger.info "=> method_level_1: start"
      uri = URI.parse(link.url)
      nokogiri_doc(uri).search('html/body/table/tr[4]/td[1]/table/tr[1]/td[1]/table//a').each do |tag_a|
        if tag_a['href'] =~ /^\?do=catalog\&cat=\d+$/
          child_link = link.children.find_or_create_by_url_and_source_id_and_name "#{uri.scheme}://#{uri.host}#{':' + uri.port.to_s if uri.port != 80}/#{tag_a['href']}", link.source_id, tag_a.content
          @logger.info "=> method_level_1: yield start"
          yield child_link if child_link.is_follow
          @logger.info "=> method_level_1: yield end"
        end
      end
@logger.info "=> method_level_1: end"
    end

    def method_level_2(link)
@logger.info "start method_level_2"
      uri = URI.parse(link.url)
      nokogiri_doc(uri).search('/html/body/table/tr[4]/td/table/tr/td[2]/table/tr[3]/td/table[2]//a').each do |tag_a|
        if tag_a['href'] =~ /^\?do=catalog\&cat=\d+$/
          child_link = link.children.find_or_create_by_url_and_source_id_and_name "#{uri.scheme}://#{uri.host}#{':' + uri.port.to_s if uri.port != 80}/#{tag_a['href']}", link.source_id, tag_a.content
          yield child_link if child_link.is_follow
        end
      end
@logger.info "end method_level_2"
    end

    def method_level_3(link)
@logger.info "start method_level_3"
      uri = URI.parse(link.url)

      first_page = nokogiri_doc(uri)

      links_to_next_pages = first_page.search('//a[@class="list"]').map { |tag_a| tag_a['href'] }
      links_to_next_pages.shift 
      links_to_next_pages.unshift(first_page).each do |element|
        nokogiri_doc(element).search('/html/body/table/tr[4]/td/table/tr/td[2]/table/tr[3]//a').each do |tag_a|
          if tag_a.content.include?('Подробнее >>')
            child_link = link.children.find_or_create_by_url_and_source_id "#{uri.scheme}://#{uri.host}#{':' + uri.port.to_s if uri.port != 80}/#{tag_a['href']}", link.source_id
            yield child_link if child_link.is_follow
          end
        end
      end
@logger.info "end method_level_3"
    end

    def grab_from_page(link)

      attributes = { :raw_html => nokogiri_doc(URI.parse(link.url)).search('/html/body/table/tr[4]/td/table/tr/td[2]/table/tr[3]/td/table[4]').first.to_s }

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
    
  end
end
