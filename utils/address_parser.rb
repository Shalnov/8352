require 'singleton'
require 'unicode'
require 'open-uri'
require 'hpricot'
require 'cgi'
require 'net/http'

class AddressParser
  include Singleton

  # Парсинг происходит так:
  #  - Запрос к Яндексу. С большой вероятностью, Яндекс выделит всё для больших городов. Для небольших (Новочебоксарск) - хотя бы, название города.
  #    Если Яндекс не нашёл город - маловероятно, что тот в принципе существует и адрес корректен.
  #  - Выделяется индекс и тип поселения (это легко), и номер офиса (чуть сложнее).
  #  - Далее, пытаемся отпарсить недостающие части адреса по простым правилам типа "ул. {улица}", "д. {дом}" и так далее.
  def parse(addr)    
    yandex_response = yandex_parse(addr)
    index = parse_index(addr)
    ctype = parse_ctype(yandex_response[:addr])
    office = parse_office(addr)    
    
    response = {
      :addr => yandex_response[:addr],
      :index => index,
      :country => yandex_response[:country],
      :city => yandex_response[:locality],
      :ctype => ctype, 
      :street => yandex_response[:thoroughfare],
      :house => yandex_response[:premise],
      :office => office
    }
    
    # Если Яндекс не вернул город, можно смело забить болт на дальнейший парсинг.
    return nil if response[:city].to_s.empty?
    
#    response[:city] = try_to_parse_city(addr) if response[:city].nil?
#    response[:street] = try_to_parse_street(addr) if response[:street].nil?
#    response[:house] = try_to_parse_house(addr) if response[:house].nil?
    
    response   
  end

protected
  # Пытается пропустить адрес через Яндекс, выделить то что удалось.
  def yandex_parse(addr)
    escaped_addr = CGI.escape(addr)
    response = Net::HTTP.get(URI.parse(YANDEX_MAPS_URI % escaped_addr))
    doc = Hpricot.XML(response)
    parse_yandex_response(doc)    
  end

  # Ищет индекс.
  def parse_index(addr)
    addr.match(/(\d{6})/)
    $1.nil? ? nil : $1.to_i
  end

  # Ищет тип поселения.
  def parse_ctype(city)
    city = Unicode::downcase(city.dup)
    CTYPES.each do |ctype|
      return ctype if city.match(/#{ctype}/u)
    end
    "город"
  end

  # Парсит номер офиса. Возможные регулярные выражения описаны в OFFICE_REGEXP.
  def parse_office(office)
    OFFICE_REGEXP.each do |r|
      return $1 if office.match(/#{r}#{OFFICE_NO_REGEXP}/iu)
    end
    nil
  end
  
  # Служебная функция, достаёт все значимые части ответа Яндекса.
  def parse_yandex_response(doc)
    el = doc.at('featureMember')
    response = YANDEX_PARSE_XPATHS.map do |key, xpath|
      cur_el = el.at(xpath)
      text = cur_el.inner_text unless cur_el.nil?
      [key, text]
    end
    Hash[*response.flatten]
  end

  YANDEX_API_KEY = 'ANpUFEkBAAAAf7jmJwMAHGZHrcKNDsbEqEVjEUtCmufxQMwAAAAAAAAAAAAvVrubVT4btztbduoIgTLAeFILaQ=='
  YANDEX_MAPS_URI = "http://geocode-maps.yandex.ru/1.x/?geocode=%s&key=#{YANDEX_API_KEY}"
  OFFICE_NO_REGEXP = '\s*(\d+\w{0,2})'
  
  # NOTE Тут засада с ебучим юникодом, поэтому, пришлось размножить регэкспы в кейзах.  
  OFFICE_REGEXP = %w(оф. Оф. Офис офис)

  YANDEX_PARSE_XPATHS = {
    :addr => 'GeocoderMetaData/text',
    :country => 'Country/CountryName',
    :locality => 'Locality/LocalityName',
    :thoroughfare => 'Thoroughfare/ThoroughfareName',
    :premise => 'Premise/PremiseNumber',
    :lower_corner => 'boundedBy/Envelope/lowerCorner',
    :upper_corner => 'boundedBy/Envelope/upperCorner'
  }
  
  CTYPES = %w(город поселок посёлок село аул деревня колония)
end