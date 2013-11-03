require 'rubygems'
require 'csv'
Bundler.require
require './lib/trainer'
Mongoid.load!("config/mongoid.yml", :development)


def capture_between(start, finish, string)
  match = string.match(/#{start}(.*)#{finish}/)
  match ? match[0].gsub("#{start}: ", "").gsub(finish, "").gsub(/\r\n|\r|\n/, '') : ""
end

url = "http://www.nrpt.co.uk/profiles/trainers/TRAINER_ID/a-n-trainer.htm"

last = Trainer.last
((last ? last.external_id : 0)..50000).each do |i|
  print "#{i} "
  response = RestClient.get(url.gsub("TRAINER_ID", "#{i}"))
  html = Nokogiri::HTML(response)  
  full_details = html.css("div.trainer p:first").inner_text

  link = html.css("p.purpleblock a.wtrk-link").first
  
  session_price = capture_between("Price", "Tel", full_details)
  unless session_price.empty?
    match = session_price.match(/\d+(\.\d{1,2})/)
    session_price = match ? match[0] : "Unknown"
  end
  
  data = {
    external_id: i,
    has_data: link ? true : false, 
    name: html.css("div.trainer h2").inner_html,
    gender: capture_between("Gender", "Age", full_details),
    age: capture_between("Age", "Price", full_details),
    session_price: session_price,
    phone_number: capture_between("Tel", "Member", full_details),
    member_since: capture_between("Member Since", "", full_details),
    website: link ? link['href'] : '',
  }
  
  trainer = Trainer.create(data)
  trainer.save
end