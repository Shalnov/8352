require 'test/unit'
require 'address_parser'

class AddressParserTest < Test::Unit::TestCase
  def test_success_parsing
    SUCCESS_ADDRESSES.each do |line, result|
      parsed = AddressParser.instance.parse(line)

      result.each do |key, value|        
        assert_equal(parsed[key], value, "Line: #{line} | #{key} was: #{parsed[key]} | #{key} should be: #{value}")
      end
    end
  end

protected
  SUCCESS_ADDRESSES = {
    "г. Санкт-Петербург" => { :city => "Санкт-Петербург", :ctype => "город" },
    "193313, Санкт-Петербург, Искровский пр., 2, оф. 192" => { :index => 193313, :city => "Санкт-Петербург", :street => "Искровский проспект", :house => "2", :office => "192" },
    "г.Новочебоксарск, ул. Винокурова, 48" => { :city => "Новочебоксарск", :street => "Винокурова" },
    "Чебоксары, ул. Текстильщиков, 10  (офис 109B)" => { :office => "109B" },
    "г. санкт-петербург, Белокрылого Орла ул., д. 50" => { :street => "Белокрылого Орла", :ctype => "город", :house => "50" }
  }
end