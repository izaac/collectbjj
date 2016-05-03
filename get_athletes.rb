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
tds_tmp = tds
tc1 = tds_tmp.css('.column-1')
tc2 = tds_tmp.css('.column-2')

# remove the header in each column
tc1.shift
tc2.shift

class Athlete
  attr_accessor :array, :name, :last, :url

  def initialize
    @array = []
    @name = ''
    @last = ''
    @url = ''
  end

end

ath = Athlete.new

for i in (0..tc1.length) do
  if tc1[i] != nil && tc2[i] != nil
   ath.name = tc1[i].text
   ath.last = tc2[i].text
   a = tc1[i].css('a')
   url = a.attribute('href').to_s
   if url.start_with?('http://') && a != nil
     ath.url = url
   elsif url.start_with?('/')
     ath.url = 'http://www.bjjheroes.com' + url
   end
   ath.array.push([ath.name, ath.last, ath.url])
  end
end

pp ath.array
#Pry.start(binding)