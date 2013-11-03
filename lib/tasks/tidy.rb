require 'rubygems'
require 'csv'
Bundler.require
require './lib/trainer'
Mongoid.load!("config/mongoid.yml", :development)

# Trainer.all.each do |t|
#   next if t.session_price.empty?
#   match = t.session_price.match(/\d+(\.\d{1,2})/)
#   price = match ? match[0] : "Unknown"
#   t.update_attributes(session_price: price)
# end


CSV.open("./pts.csv", "wb") do |csv|
  csv << [
    :external_id,
    :has_data,
    :name,
    :gender,
    :age,
    :session_price,
    :phone_number,
    :member_since,
    :website,
  ]
  Trainer.all.each do |t|
    next unless t.has_data
    csv << [
      t.external_id,
      t.has_data,
      t.name,
      t.gender,
      t.age,
      t.session_price,
      t.phone_number,
      t.member_since,
      t.website
    ]
  end
end