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
tds.map do |i|
  a = i.css('a')
  puts i.text if i.text != ''
  puts a if i.text != ''
  if a != nil
    puts a.attribute('href')
  end
end
#Pry.start(binding)