
class FareDataService

	include ActionView::Helpers::TextHelper

	def convert results

		itins = []
		results['PricedItineraries'].each do |pi|
			
			itin = {}

			# TODO add a table for currency and store the symbol before TotalFare
			itin['TotalFare'] = pi['AirItineraryPricingInfo']['ItinTotalFare']['TotalFare']['Amount'].to_s
			itin['TotalFareCurrencyCode'] = pi['AirItineraryPricingInfo']['ItinTotalFare']['TotalFare']['CurrencyCode']
			
			# Tack on the currency symbol
			c = Currency.find_by code: itin['TotalFareCurrencyCode']
			itin['TotalFare'] = c.symbol + itin['TotalFare'] if c

			itin['Legs'] = []
			leg_count = 0

			pi['AirItinerary']['OriginDestinationOptions']['OriginDestinationOption'].each do |odo|
		
				leg = {}
				
				# The second leg is the return leg 
				leg_count += 1
				if leg_count == 1
					leg['Name'] = 'Leave'
				elsif leg_count == 2
					leg['Name'] = 'Return'
				else
					leg['Name'] = ''
				end	

				leg['Duration'] = minutes_in_hours(odo['ElapsedTime'])
				
				# Store flight segments into a temp variable
				fss = odo['FlightSegment']

				# Store depart and arrive leg times into temp variables
				depart = fss[0]['DepartureDateTime']
				arrive = fss[-1]['ArrivalDateTime']

				# Format like Sun, Dec 6
				leg['DepartDate'] = to_dt(depart).strftime("%a, %b %e")

				# Format like  5:30 pm
				leg['DepartTime'] = to_dt(depart).strftime("%l:%M %P")
				leg['ArriveTime'] = to_dt(arrive).strftime("%l:%M %P")

				# How many days difference
				day_diff = to_d(arrive).mjd - to_d(depart).mjd
				if day_diff < 0
					leg['DayDiff'] = day_diff.to_s
					leg['ArriveDesc'] = 'Arrive ' + to_dt(arrive).strftime("%a, %b %e") + ' (' + pluralize(day_diff,'day') + ' earlier)' 
				elsif day_diff == 0	
					leg['DayDiff'] = ''
					leg['ArriveDesc'] = ''
				else
					leg['DayDiff'] = "+" + day_diff.to_s
					leg['ArriveDesc'] = 'Arrive ' + to_dt(arrive).strftime("%a, %b %e") + ' (' + pluralize(day_diff,'day') + ' later)' 
				end

				# How many stops 
				stops = fss.count - 1
				if stops < 1
					leg['Stops'] = 'non-stop'
					leg['StopAPCode'] = ''
					leg['StopAPDetails'] = ''
					leg['StopDuration'] = ''
				elsif stops == 1
					leg['Stops'] = '1 stop'
					leg['StopAPCode'] = fss[0]['ArrivalAirport']['LocationCode']
					ap = Airport.find_by :code => leg['StopAPCode']
					if ap	
						leg['StopAPDetails'] = ap.city.name + ' - ' + ap.name
					else	
						leg['StopAPDetails'] = '' 
					end
					leg['StopDuration'] = minutes_in_hours(odo['ElapsedTime'] - fss[0]['ElapsedTime'] - fss[1]['ElapsedTime'])
				else	
					leg['Stops'] = stops.to_s + ' stops'
					leg['StopAPCode'] = ''
					leg['StopAPDetails'] = ''
					leg['StopDuration'] = ''
				end	

				# Set the first and last airports for this leg
				leg['DepartAPCode'] = fss[0]['DepartureAirport']['LocationCode']
				ap = Airport.find_by :code => leg['DepartAPCode']
				if ap	
					leg['DepartAPDetails'] = ap.city.name + ' - ' + ap.name
				else	
					leg['DepartAPDetails'] = '' 
				end
				leg['ArriveAPCode'] = fss[-1]['ArrivalAirport']['LocationCode']
				ap = Airport.find_by :code => leg['ArriveAPCode']
				if ap	
					leg['ArriveAPDetails'] = ap.city.name + ' - ' + ap.name
				else	
					leg['ArriveAPDetails'] = '' 
				end

				# Test if all airlines are same
				als = []
				fss.each do |fs|
					# I wander if I should use MarketingAirline instead?
					als << fs['OperatingAirline']['Code']
				end
				als = als.uniq
				if als.count == 1
					leg['AirlineCode'] = als[0]
					al = Airline.find_by :code => als[0]
					if al
						leg['Airline'] = al.name
					else	
						leg['Airline'] = ''
					end
				elsif als.count == 2
					leg['AirlineCode'] = 'Multiple Airlines'
					al1 = Airline.find_by :code => als[0]
					al2 = Airline.find_by :code => als[1]
					if al1 && al2
						leg['Airline'] = al1.name + ' - ' + al2.name
					else	
						leg['Airline'] = ''
					end
				else	
					leg['AirlineCode'] = 'Multiple Airlines'
					leg['Airline'] = ''
				end

				# Now setup the segments for this leg
				leg['Segs'] = []

				fss.each do |fs|

					seg = {}

					# Set Departure airport name, city and country
					seg['DepartAPCode'] = fs['DepartureAirport']['LocationCode']
					ap = Airport.find_by code: seg['DepartAPCode']
					if ap	
						seg['DepartAP'] = ap.name
						seg['DepartCity'] = ap.city.name
						seg['DepartCountry'] = ap.city.country.name
					else	
						seg['DepartAP'] = ''
						seg['DepartCity'] = ''
						seg['DepartCountry'] = ''
					end
							
					# Set arrival airport name, city and country		
					seg['ArriveAPCode'] = fs['ArrivalAirport']['LocationCode']
					ap = Airport.find_by :code => seg['ArriveAPCode']
					if ap
						seg['ArriveAP'] = ap.name
						seg['ArriveCity'] = ap.city.name
						seg['ArriveCountry'] = ap.city.country.name
					else		
						seg['ArriveAP'] = ''
						seg['ArriveCity'] = ''
						seg['ArriveCountry'] = ''
					end
							
					# I wander if I should use MarketingAirline instead?
					seg['AirlineCode'] = fs['OperatingAirline']['Code']
					al = Airline.find_by :code => seg['AirlineCode']
					if al
						seg['Airline'] = al.name
					else	
						seg['Airline'] = ''
					end

					# Set plane type
					seg['PlaneTypeCode'] = fs['Equipment']['AirEquipType']	
					ac = Aircraft.find_by :code => seg['PlaneTypeCode']
					if ac
						seg['PlaneType'] = ac.name
					else	
						seg['PlaneType'] = ''
					end

					# Set flight number
					seg['FlightNum'] = fs['OperatingAirline']['FlightNumber']

					# Format like Sun, Dec 06 5:30 pm
					seg['DepartDateTime'] = to_dt(fs['DepartureDateTime']).strftime("%a, %b %e %l:%M %P")	
					seg['ArriveDateTime'] = to_dt(fs['ArrivalDateTime']).strftime("%a, %b %e %l:%M %P")
					seg['Duration'] = minutes_in_hours(fs['ElapsedTime'])

					leg['Segs'] << seg
					
				end	
				
				itin['Legs'] << leg

			end

			itins << itin
		
		end

		itins

	end
	
private 

  def to_dt t
  	# 2015-12-07T11:00:00 is the input data format
	DateTime.new(t[0..3].to_i, t[5..6].to_i, t[8..9].to_i, t[11..12].to_i, t[14..15].to_i, t[17..18].to_i )	
  end

  def to_d t
	# 2015-12-07T11:00:00 is the input data format
  	Date.parse(t[0..9])
  end	

  def minutes_in_hours(minutes)
  	# Converts minutes to output like 21h 35m

  	return '' if minutes == 0
  	h = ''
  	h = (minutes / 60).to_s + 'h' if minutes >= 60
  	m = (minutes % 60)
  	if m > 0
  		h += ' ' + m.to_s + 'm'
  	end	
  	h.strip
  end

		
end

