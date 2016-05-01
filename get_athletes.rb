require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

agent = 'User-Agent'
page = nil

if File.file?('tmp.html')
  page = open('tmp.html', 'r')
else
  page = HTTParty.get('http://www.bjjheroes.com/a-z-bjj-fighters-list',
                      headers: {agent =>
                                    'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'})
  target = open('tmp.html', 'w')
  target.write(page)
  target.close
end

parsed_page = Nokogiri::HTML(page)
page.close if page.is_a?(File)

tds = parsed_page.css('.column-2 , .column-1')
tds = tds.drop(2)

class Athlete
  attr_accessor :array, :name, :last, :url

  def initialize
    @array = []
    @name = ''
    @last = ''
    @url = ''
  end

end

num = 1
tds.map do |i|
  puts i.text if i.text != ''
  if num.even?
    a = i.css('a')
    url = a.attribute('href').to_s
    if url.start_with?('http://') && a != nil
      puts url
    elsif url.start_with?('/')
      puts 'http://www.bjjheroes.com' + url
      puts
      end
  end
  num += 1
end

#Pry.start(binding)