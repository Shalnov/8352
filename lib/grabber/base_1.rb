require 'rubygems'
require 'nokogiri'
require 'open-uri'

class ItemsCrawler

  def crawl
    results = []
    get_categories_urls.each do |url|
      data = extract_data(url)
      results << data if data
    end
    results
  end

  private

  def get_categories_urls
    links = []
    doc = Nokogiri::HTML(open("#{HOST}/catalogue"))
    doc.css('div.list a').each do |link|
      links << link['href'] if link['href'].include?('htm')
    end
    links
  end

  def extract_data(url)
    puts "Getting - #{HOST+url}"
    html = open(HOST+url).read
    html = Iconv.iconv('utf-8', 'cp1251', html)

    # Нужно заменить, иначе nokogiri его трактует как windows-1251
    doc = Nokogiri::HTML(html[0].gsub('charset=windows-1251"', 'charset=utf-8"'))

    # Далее получение аттрибутов с помощью xpath или css селектора

    title = doc.search('title').first.contet
    description = doc.search('div.content').first.inner_html # Получение содержания со всеми тегами
    {:title => title, :description => description}
  end
  end
