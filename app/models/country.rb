# == Schema Information
#
# Table name: countries
#
#  id            :integer          not null, primary key
#  code          :string
#  name          :string
#  point_of_sale :boolean
#

class Country < ActiveRecord::Base

	has_many :cities
	
end
