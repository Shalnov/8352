  module Grabber
  class ChebRu < Grabber::Base

    require 'open-uri'
    require 'nokogiri'
    require 'logger'

    attr_reader :target, :target_url, :target_uri, :target_description, :target_domain, :level_methods

    def initialize
      super
      @target_url = 'http://www.cheb.ru/spravka/'
      @target_description = 'www.cheb.ru'
#      super
      @target_uri = URI.parse(@target_url)
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
#        update_results(link_to_page, grab_from_page(link_to_page)) unless link_to_page.is_appeared
      end
    end
#   -----------------------------------------------------------------------
#   -----------------------------------------------------------------------
    def method_level_1(link)
      uri = URI.parse(link.url)

      nokogiri_doc(uri).search('/html/body/table/tr/td/table[3]/tr/td[4]//table//a').each do |tag_a|
        normalized_link = normalize_link(tag_a['href'])
        child_link = link.children.find_by_url_and_source_id( normalized_link || tag_a['href'], link.source_id )
        unless child_link
          child_link = link.children.create :url => normalized_link || tag_a['href'],
                                            :name => tag_a.content,
                                            :source_id => link.source_id,
                                            :is_follow => ( normalized_link && (URI.parse(normalized_link).host == uri.host))
        end
        yield child_link if child_link.is_follow
      end
    end

    def method_level_2(link)
      @logger.info "method_level_2 for #{link.url}"
      uri = URI.parse(link.url)

      nokogiri_doc(uri).search('/html/body/table/tr/td/table[3]/tr/td[4]//h2//a').each do |tag_a|
        normalized_link = normalize_link(tag_a['href'])
        child_link = link.children.find_by_url_and_source_id( normalized_link || tag_a['href'], link.source_id )
        unless child_link
          child_link = link.children.create :url => normalized_link || tag_a['href'],
                                            :name => tag_a.content,
                                            :source_id => link.source_id,
                                            :is_follow => ( normalized_link && (URI.parse(normalized_link).host == uri.host))
        end
        yield child_link if child_link.is_follow
      end
    end

    def grab_from_page(link)

      doc = nokogiri_doc(URI.parse(link.url)).search('/html/body/table/tr/td/table[3]/tr/td[4]/table')

      attributes = { :raw_html => doc.first.to_s }

#      Nokogiri::HTML(attributes[:raw_html]).search('//td').each do |tag_td|
#        td = tag_td.content
#        if td.include?('Название:') && !attributes.include?(:name)
#          attributes.merge! :name => td.sub('Название:','').strip
#
#        elsif td.include?('Адрес:') && !attributes.include?(:address)
#          attributes.merge! :address => td.sub('Адрес:','').strip
#
#        elsif td.include?('Телефон:') && !attributes.include?(:phones)
#          attributes.merge! :phones => td.sub('Телефон:','').strip
#
#        elsif td.include?('Раздел:') && !attributes.include?(:category)
#          attributes.merge! :category => td.sub('Раздел:','').strip
#
#        elsif td.include?('E-mail:') && !attributes.include?(:email)
#          attributes.merge! :email => td.sub('E-mail:','').strip
#
#        else
#          if attributes.include?(:other_info)
#            attributes[:other_info] += td.strip
#          else
#            attributes.merge! :other_info => td.strip
#          end
#        end
#      end
      attributes
    end
    
#    def update_results(grab_link, grab_result)
#      # save changes to db
#    end
##   -----------------------------------------------------------------------
  end

end

#  def record_progress(progress)
#
#  end
