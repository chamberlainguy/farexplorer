
class FareDataServiceNextVersion

#   include ActionView::Helpers::TextHelper


#   def convert results

#     itins = []
#     results['PricedItineraries']['PricedItinerary'].each do |pi|
      
#       itin = {}

#       itin['Itins'] = []

#       itin['TicketType'] = pi['DirectionInd']

#       pi["OriginDestinationOptions"]["OriginDestinationOption"].each do |fseg|

#         fseg = {}
#         fseg['Legs'] = []
#         fseg['Time'] = minutes_in_hours(fseg['ElapsedTime'])
      
#         fseg['Flightsegment'].each do |seg|

#             leg = {}

#             # Store depart and arrive leg times into temp variables
#             depart = seg['DepartureDateTime']
#             arrive = seg['ArrivalDateTime']

#             # Format like Sun, Dec 6
#             leg['DepartDate'] = to_dt(depart).strftime("%a, %b %e")

#             # Format like  5:30 pm
#             leg['DepartTime'] = to_dt(depart).strftime("%l:%M %P")
#             leg['ArriveTime'] = to_dt(arrive).strftime("%l:%M %P")

#             # How many days difference
#             day_diff = to_d(arrive).mjd - to_d(depart).mjd
#             if day_diff < 0
#               leg['DayDiff'] = day_diff.to_s
#               leg['ArriveDesc'] = 'Arrive ' + to_dt(arrive).strftime("%a, %b %e") + ' (' + pluralize(day_diff,'day') + ' earlier)' 
#             elsif day_diff == 0 
#               leg['DayDiff'] = ''
#               leg['ArriveDesc'] = ''
#             else
#               leg['DayDiff'] = "+" + day_diff.to_s
#               leg['ArriveDesc'] = 'Arrive ' + to_dt(arrive).strftime("%a, %b %e") + ' (' + pluralize(day_diff,'day') + ' later)' 
#             end

#             leg['StopQuantity'] = seq['StopQuantity'] 
#             leg['FlightNumber'] = seg['FlightNumber'] 

#             leg['Time'] = minutes_in_hours(seg['ElapsedTime'])
      
#             leg['DepartureAirport'] = seg['DepartureAirport']['LocationCode'] 

#             leg['ArrivalAirport'] = seg['ArrivalAirport']['LocationCode'] 

#             # I wander if I should use MarketingAirline instead?
#             leg['AirlineCode'] = fs['OperatingAirline']['Code']
#             al = Airline.find_by :code => leg['AirlineCode']
#             if al
#               leg['Airline'] = al.name
#             else  
#               leg['Airline'] = ''
#             end

#             fseg['Legs'] << leg

#         end

#         itin['Itins'] << itin

#       end

#       itins << itin
    
#     end  

#     itins

# end

# private 

#   def to_dt t
#     # 2015-12-07T11:00:00 is the input data format
#   DateTime.new(t[0..3].to_i, t[5..6].to_i, t[8..9].to_i, t[11..12].to_i, t[14..15].to_i, t[17..18].to_i ) 
#   end

#   def to_d t
#   # 2015-12-07T11:00:00 is the input data format
#     Date.parse(t[0..9])
#   end 

#   def minutes_in_hours(minutes)
#     # Converts minutes to output like 21h 35m

#     return '' if minutes == 0
#     h = ''
#     h = (minutes / 60).to_s + 'h' if minutes >= 60
#     m = (minutes % 60)
#     if m > 0
#       h += ' ' + m.to_s + 'm'
#     end 
#     h.strip
#   end

    
end

