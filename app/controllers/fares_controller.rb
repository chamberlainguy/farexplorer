class FaresController < ApplicationController
  
  
  def search
  end  

  def selecto
  	
  	@cities = []
  	session[:origin].each do |city_code|
		    city = City.find_by :code => city_code
		    @cities << {citycode: city.code,
					         cityname: city.name,
			             countryname: city.country.name}
	  end	
	
  end

  def selectd

	 @cities = []
    session[:destination].each do |city_code|
		city = City.find_by :code => city_code
		@cities << {citycode: city.code,
					     cityname: city.name,
			         countryname: city.country.name}
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
  	redirect_to fares_path

  end

  def index

  	# try  ORD  to  LGA
  	#      ORD  to  LAX
  	#      DFW  to  LAX
  	#      JFK  to  AMS
  	#      JFK  to  LAX
  	#   chicago to  LGA
  	#   chicago to los angeles
  	#   dallas  to new york
  	#   berlin  to los angeles   (has 2 stops!)

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

    # Check if this origin is a point of sale country
    poscountry = set_poscountry session[:origin]
    unless poscountry
      @notice = 'Origin is not in a Point of Sale country'
      render :search and return
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
    
   	# Testing
	  # token = SabreDevStudio::Base.get_access_token

    h = '/v1/shop/flights?origin=' + session[:origin] + '&destination=' + session[:destination] + '&departuredate=' + session[:departuredate] + '&returndate=' + session[:returndate] + '&pointofsalecountry=' + poscountry + '&limit=50'

	  results = SabreDevStudio::Base.get(h)  # Take the first Href. it works

	  @itins = FareDataService.new.convert results

  
  end

  def show
  end

  private

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

	def set_poscountry place
		# check if it is an airport
        ret_value = nil
        ap = Airport.find_by :code => place
        if ap.present?
        	ret_value = ap.city.country.code if ap.city.country.point_of_sale
        else
        	# Try find by city
        	city = City.find_by :code => place
        	if city.present?
        		ret_value = city.country.code if city.country.point_of_sale
        	else	
        		ret_value = nil
        	end	
        end
        ret_value
	end        


end
