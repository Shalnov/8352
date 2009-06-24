  module Grabber
  class ChebRu < Grabber::Base

    require 'open-uri'
    require 'nokogiri'
    require 'logger'

    attr_reader :target, :target_url, :target_description, :level_methods

    def initialize
      super
      @target_url = 'http://www.cheb.ru/spravka/'
      @target_description = 'www.cheb.ru'
      @target = Source.find_by_grabber_module(self.class.to_s.split('::').last)
      @target.links.create :url => @target_url if @target.links.root.nil?
      @target.results.each {|r| r.update_attributes :is_checked => false, :is_updated => false }
    end
    
#      progress = 0
#      record_progress(progress)
#   -----------------------------------------------------------------------
    def run
      link_collector(@target_url) do |link_to_page|
        update_results(link_to_page, grab_from_page(link_to_page)) unless link_to_page.is_appeared
      end
    end
#   -----------------------------------------------------------------------
    def link_collector link, &block
      self.send(@level_methods.shift.to_sym, link) do |next_level_link|
        if @level_methods.empty?
          yield next_level_link if block_given?
        else
          link_collector next_level_link, &block
        end
      end
    end
#   -----------------------------------------------------------------------
    def update_results(grab_link, grab_result)
      # save changes to db
    end
#   -----------------------------------------------------------------------
#   -----------------------------------------------------------------------
    def method_level_1(link)
      yield link
    end

    def method_level_2(link)
      yield link
    end

    def method_level_3(link)
      yield link
    end

#    def method_level_X(link)
#      yield link
#    end

    def grab_from_page(link)
    end
    
  end

end

#  def record_progress(progress)
#
#  end
