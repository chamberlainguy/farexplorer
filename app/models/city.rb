class City < ActiveRecord::Base

	has_many :airports
	belongs_to :country

end
