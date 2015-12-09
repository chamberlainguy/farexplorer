class Fares2Controller < ApplicationController

include ActionView::Helpers::TextHelper
# require 'pry'

def search

  end


  def selecto
    
    @cities = []
    session[:origin].each do |city_code|
        city = City.find_by :code => city_code
        
        aps = ""
        city.airports.each do |ap|
           aps += '(' + ap.code + ') ' + ap.name 
        end

        @cities << {citycode: city.code,
                         cityname: city.name,
                     countryname: city.country.name,
                     airports: aps}        
      end   
    
  end

  def selectd

     @cities = []
    session[:destination].each do |city_code|
        city = City.find_by :code => city_code
        
        aps = ""
        city.airports.each do |ap|
           aps += '(' + ap.code + ') ' + ap.name 
        end

        @cities << {citycode: city.code,
                         cityname: city.name,
                     countryname: city.country.name,
                     airports: aps}        
     end    

  end


  def selectod
    # Select origin done
    session[:origin] = params[:city]
    redirect_to fares_path
  end

  def selectdd
    # Select destination done
    session[:destination] = params[:city]
    redirect_to fares_path
  end

  
  def searchinit

    session[:origin] = params[:origin]
    session[:destination] = params[:destination]
    session[:departuredate] = params[:departuredate]
    session[:returndate] = params[:returndate]
    session[:departuretime] = params[:departuretime]
    session[:returntime] = params[:returntime]

    redirect_to fares_path

  end


  def index

# Validate origin
    session[:origin] = validate_and_convert_city_name(session[:origin])
    unless session[:origin].present?
        @notice = 'Origin is invalid'
        render :search and return
    end
    
    # Check if origin is unique
    if session[:origin].count > 1
        return redirect_to selecto_path
    else
        session[:origin] = session[:origin][0]
    end 

    # Validate destination
    session[:destination] = validate_and_convert_city_name(session[:destination])
    unless session[:destination].present?
        @notice = 'Destination is invalid'
        render :search and return
    end

    # Check if destination is unique
    if session[:destination].count > 1
        return redirect_to selectd_path
    else
        session[:destination] = session[:destination][0]
    end 

 # TODO add the correct time to the arrive and depart timestamps



# Support first only simply itineries
@therequest = 
 {
    "OTA_AirLowFareSearchRQ": {
        "Target": "Production",
        "POS": {
            "Source": [{
                "RequestorID": {
                    "Type": "1",
                    "ID": "1",
                    "CompanyName": {
                        "Code": "TN"
                    }
                }
            }]
        },
        "OriginDestinationInformation": [{
            "RPH": "1",
            "DepartureDateTime": session[:departuredate]+"T11:00:00",
            "OriginLocation": {
                "LocationCode": session[:origin]
            },
            "DestinationLocation": {
                "LocationCode": session[:destination]
            },
            "TPA_Extensions": {
                "SegmentType": {
                    "Code": "O"
                }
            }
        },
          {
             "RPH": "2",
             "DepartureDateTime": session[:returndate]+"T11:00:00",
             "OriginLocation": {
                 "LocationCode": session[:destination]
             },
             "DestinationLocation": {
                 "LocationCode": session[:origin]
             },
             "TPA_Extensions": {
                 "SegmentType": {
                     "Code": "O"
                 }
             }
         }
        ],
        "TravelPreferences": {
            "ValidInterlineTicket": true,
            "CabinPref": [{
                "Cabin": "Y",
                "PreferLevel": "Preferred"
            }],
            "TPA_Extensions": {
                "TripType": {
                    "Value": "Return"
                },
                "LongConnectTime": {
                    "Min": 780,
                    "Max": 1200,
                    "Enable": true
                },
                "ExcludeCallDirectCarriers": {
                    "Enabled": true
                }
            }
        },
        "TravelerInfoSummary": {
            "SeatsRequested": [1],
            "AirTravelerAvail": [{
                "PassengerTypeQuantity": [{
                    "Code": "ADT",
                    "Quantity": 1
                }]
            }]
        },
        "TPA_Extensions": {
            "IntelliSellTransaction": {
                "RequestType": {
                    "Name": "50ITINS"
                }
            }
        }
    }
}



 # Testing
     SabreDevStudio.configure do |c|
       c.client_id     = 'V1:1iy62gr6fh6yi2e8:DEVCENTER:EXT'
       c.client_secret = '2CPxfDl2'
       c.uri           = 'https://api.test.sabre.com'
      end

 	   @token = SabreDevStudio::Base.get_access_token

		headers = {
          'Authorization'   => "Bearer #{@token}",
          'Accept-Encoding' => 'gzip',
          'Content-Type' => 'application/json'
        }

    results = HTTParty.post("https://api.test.sabre.com/v1.9.0/shop/flights?mode=live", 
    
    #:body => WebSampleRequest.new.thedata.to_json,
     :body => @therequest.to_json,

    # :token =>  @token 
    # :ssl_version => :TLSv1,
    :headers => headers ) 


      # @itins = convert results

     
     # Sort by price only
     # @itins = @itins.sort_by { |k| k["Price"] }
    
     # Sort by segment number only
     # @itins = @itins.sort_by { |k| k["Legs"][0]["Segs"].count + k["Legs"][-1]["Segs"].count }
    
     # Sort by Segments count THEN by price
     # @itins = @itins.sort_by { |k| [ k["Legs"][0]["Segs"].count + k["Legs"][-1]["Segs"].count, k["Price"] ] }
    
     
     bf_id = write_fb_session results 
    
     @legs = get_legs bf_id

  end

private





def write_fb_session results

  # TODO if a bd.id is passed in then use it instead of creating

  bf = Bfsession.create

  results['OTA_AirLowFareSearchRS']['PricedItineraries']['PricedItinerary'].each do |pi|

      it = Itin.create ticket_type:
                        pi['AirItinerary']['DirectionInd'],
                        price:
                        pi['AirItineraryPricingInfo'][0]['ItinTotalFare']['BaseFare']['Amount'],
                        curr_code:
                        pi['AirItineraryPricingInfo'][0]['ItinTotalFare']['BaseFare']['CurrencyCode']

      bf.itins << it                  

      leg_seq = 0

      pi["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"].each do |aleg|

        leg_seq += 1

        search_key = make_search_key(aleg, leg_seq, bf.id)

        le = Leg.find_by :search_key => search_key

        if le.present? 

          it.legs << le

        else
          # Now make this leg

          le = Leg.create seq:
                          leg_seq,
                          search_key:
                          search_key,
                          flight_mins:
                          aleg['ElapsedTime']
          it.legs << le     

          bf.legs << le           

          # Now make the segments

          aleg['FlightSegment'].each do |aseg| 

            se = Seg.create  depart_datetime: aseg['DepartureDateTime'],
                    arrive_datetime: aseg['ArrivalDateTime'],
                    stop_quantity: aseg['StopQuantity'],
                    flight_num: aseg['FlightNumber'],
                    depart_airport_code: aseg['DepartureAirport']['LocationCode'],
                    arrive_airport_code: aseg['ArrivalAirport']['LocationCode'],
                    flight_mins: aseg['ElapsedTime'],
                    mark_airline_code: aseg['MarketingAirline']['Code'],
                    op_airline_code: aseg['OperatingAirline']['Code']

            le.segs << se

          end  

        end  

      end

  end

  # bf.destroy

  return bf.id

end

def get_legs bf_id

    bf = Bfsession.find bf_id

    legs = []
    bf.legs.each do |aleg|
      if aleg.seq = 1
        leg = {}
        # Find the lowest and highest price for this leg
        low_price = 9999999.99
        high_price = 0
        aleg.itins.each do |aitin|
          if aitin.price < low_price
            low_price = aitin.price
          end      
          if aitin.price > high_price
            high_price = aitin.price
          end
        end
        leg['LowPrice'] = low_price
        leg['HighPrice'] = high_price
        leg['Stops'] = aleg.segs.count - 1
        legs << leg
      end
    end

    legs = legs.sort_by { |k| [ k["Stops"], k["LowPrice"] ] }

    legs
end



def make_search_key (aleg, leg_seq, bf_id)

  key = bf_id.to_s + "#" + leg_seq.to_s 
  aleg['FlightSegment'].each do |aseg| 
    key += "#" + aseg['FlightNumber'] + "#" + aseg['DepartureDateTime'] 
  end  

  key

end

def convert results

    itincount = 0 

    itins = []
    results['OTA_AirLowFareSearchRS']['PricedItineraries']['PricedItinerary'].each do |pi|
      
      itin = {}

      itin['TicketType'] = pi['AirItinerary']['DirectionInd']

      itin['Price'] = pi['AirItineraryPricingInfo'][0]['ItinTotalFare']['BaseFare']['Amount']

      itin['CurrencyCode'] = pi['AirItineraryPricingInfo'][0]['ItinTotalFare']['BaseFare']['CurrencyCode']
      
      itin['Legs'] = []

      pi["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"].each do |aleg|

        leg = {}
         
        leg['FlightTime'] = minutes_in_hours(aleg['ElapsedTime'])
        leg['Segs'] = []

        aleg['FlightSegment'].each do |aseg| 

            seg = {}

            # Store depart and arrive leg times into temp variables
            depart = aseg['DepartureDateTime']
            arrive = aseg['ArrivalDateTime']

            # Format like Sun, Dec 6
            seg['DepartDate'] = to_dt(depart).strftime("%a, %b %e")

            # Format like  5:30 pm
            seg['DepartTime'] = to_dt(depart).strftime("%l:%M %P")
            seg['ArriveTime'] = to_dt(arrive).strftime("%l:%M %P")

            # How many days difference
            day_diff = to_d(arrive).mjd - to_d(depart).mjd
            if day_diff < 0
              seg['DayDiff'] = day_diff.to_s
              seg['ArriveDesc'] = 'Arrive ' + to_dt(arrive).strftime("%a, %b %e") + ' (' + pluralize(day_diff,'day') + ' earlier)' 
            elsif day_diff == 0 
              seg['DayDiff'] = ''
              seg['ArriveDesc'] = ''
            else
              seg['DayDiff'] = "+" + day_diff.to_s
              seg['ArriveDesc'] = 'Arrive ' + to_dt(arrive).strftime("%a, %b %e") + ' (' + pluralize(day_diff,'day') + ' later)' 
            end

            seg['StopQuantity'] = aseg['StopQuantity'] 
            seg['FlightNumber'] = aseg['FlightNumber'] 

            seg['Time'] = minutes_in_hours(aseg['ElapsedTime'])
      
            seg['DepartureAirport'] = aseg['DepartureAirport']['LocationCode'] 

            seg['ArrivalAirport'] = aseg['ArrivalAirport']['LocationCode'] 

            # I wander if I should use MarketingAirline instead?
            seg['AirlineCode'] = aseg['OperatingAirline']['Code']
            al = Airline.find_by :code => seg['AirlineCode']
            if al
              seg['Airline'] = al.name
            else  
              seg['Airline'] = ''
            end

            leg['Segs'] << seg

        end

        itin['Legs'] << leg

      end

      itins << itin

    end  

    itins

end


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
    return '' if minutes == nil
    h = ''
    h = (minutes / 60).to_s + 'h' if minutes >= 60
    m = (minutes % 60)
    if m > 0
      h += ' ' + m.to_s + 'm'
    end 
    h.strip
  end



    def validate_and_convert_city_name place
        # check if it is an airport
        place = place.upcase
        ap = Airport.find_by :code => place
        if ap.present?
            return [place]
        else
            # Try find by city
            city = City.find_by :code => place
            if city.present?
                return [place]
            else    
                # Try find by city name and convert to city code
                s = place + '%'
                cities = City.where('upper(name) LIKE ?', s).all
                if cities.present?
                    c = []
                    cities.each do |city|
                break if c.count >= 10     # Max number of cities permitted
                        c << city.code      
                    end 
                    return c
                else
                    return nil
                end 
            end 
        end
    end        




end


