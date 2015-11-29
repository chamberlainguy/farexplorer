# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


iatakey = '396a4c10-3aff-4de0-aa92-49d4bfe91ac2'

puts 'Loading Countries...'

Country.destroy_all
# url = "http://iatacodes.org/api/v2/countries?api_key=#{iatakey}"
# res = HTTParty.get url
# res['response'].each do |country|

# 		Country.create code: country['code'],
# 		           	   name: country['name']
	           
# end

	    Country.create code: 'AU',
		           	   name: 'Australia'
	           
	    Country.create code: 'US',
		           	   name: 'United States'
	           

# Set point of sale
SabreDevStudio.configure do |c|
  		c.client_id     = 'V1:1iy62gr6fh6yi2e8:DEVCENTER:EXT'
  		c.client_secret = '2CPxfDl2'
  		c.uri           = 'https://api.test.sabre.com'
end
token = SabreDevStudio::Base.get_access_token
res = SabreDevStudio::Base.get('/v1/lists/supported/pointofsalecountries')
count = 0
res['Countries'].each do |c|
	country = Country.find_by :code => c['CountryCode']
	if country.present?
		country['point_of_sale'] = true
		country.save
		count += 1
	end
end
puts count.to_s + ' Points of sale...'


puts 'Loading Cities...'

City.destroy_all
url = "http://iatacodes.org/api/v2/cities?api_key=#{iatakey}"
res = HTTParty.get url
res['response'].each do |city|
	country = Country.find_by :code => city['country_code']
	if country.present?
		City.create code: city['code'],
			        name: city['name'],
		    	    country: country
    else
    	puts 'Country not found' + city['country_code']
    end
end

# Test the associations
city = City.find_by :code => 'SYD'
puts city.name + ' is in ' + city.country.name

puts 'Loading Airports...'

Airport.destroy_all
url = "http://iatacodes.org/api/v2/airports?api_key=#{iatakey}"
res = HTTParty.get url
res['response'].each do |airport|
	city = City.find_by :code => airport['city_code']
	if city.present? 
		Airport.create code: airport['code'],
			           name: airport['name'],
			           city: city 
	else 
		puts 'City not found :' + airport['city_code']
	end	
end

# Test the associations
airport = Airport.find_by :code => 'JFK'
puts airport.name + ' is in ' + airport.city.name 
puts 'which is in ' + airport.city.country.name 

# Store airlines with pictures from... or use S3 ?
#  or load pic to Cloudinary?
# http://pics.avs.io/200/20/AA.png

puts 'Loading Alrlines...'

Airline.destroy_all
url = "http://iatacodes.org/api/v2/airlines?api_key=#{iatakey}"
res = HTTParty.get url
res['response'].each do |airline|
	 
	 # There's alot of duplicates so use begin rescue
	 begin
		 Airline.create code: airline['code'],
			           name: airline['name']
	 rescue

	 end
end

# Don't worry about tax codes

# Store Aircrafts

puts 'Loading Aircrafts...'

Aircraft.destroy_all
url = "http://iatacodes.org/api/v2/aircrafts?api_key=#{iatakey}"
res = HTTParty.get url
res['response'].each do |aircraft|
		Aircraft.create code: aircraft['code'],
			            name: aircraft['name']		
end

# After all this work out MY json to send to view


puts 'Dont forget to load currencies manually in rails db'

# Dont forget to also load the currencies table
#
# $ heroku pg:credentials DATABASE    # to get the password!!
# $ heroku run rails db
#   \i currencies.sql
#








