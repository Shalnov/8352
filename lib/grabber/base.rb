module Grabber
  class Base

#    include BackgroundFu::WorkerMonitoring

    attr_reader :number_of_attempts

    def initialize
      @number_of_attempts = 3
    end

#   -----------------------------------------------------------------------
    # collect links for grabbing
   def link_collector link, &block
      method = @level_methods.shift
      self.send(method.to_sym, link) do |next_level_link|
        if @level_methods.empty?
          yield next_level_link #if block_given?
        else
          link_collector next_level_link, &block
        end
      end
      @level_methods.unshift method
    end
#   -----------------------------------------------------------------------
    # fetching html page and converting from windows-1251 to utf-8 (for Nokogiri)
    def nokogiri_doc uri
      uri = case uri
              when String    then URI.parse(uri)
              when URI::HTTP then uri
              else return uri
            end
      html = uri.open.read
      if html =~ /charset=windows-1251"/
        html = Iconv.iconv('utf-8', 'cp1251', html)
        html = html.first.gsub('charset=windows-1251"', 'charset=utf-8"')
      end
      Nokogiri::HTML(html)
    end
#   -----------------------------------------------------------------------
    # convert relative link to absolute
    def normalize_link link
      begin
        uri = URI.parse(link)
        if uri.relative?
          "#{@target_uri.scheme}://#{@target_uri.host}#{':' + @target_uri.port.to_s if @target_uri.port != 80}" + "/#{link}".gsub('//','/')
        else
          link
        end
      rescue URI::InvalidURIError
        false
      end
    end
#   -----------------------------------------------------------------------
  end
end

