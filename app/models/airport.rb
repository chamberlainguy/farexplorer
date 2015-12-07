# == Schema Information
#
# Table name: airports
#
#  id      :integer          not null, primary key
#  code    :string
#  name    :string
#  city_id :string
#

class Airport < ActiveRecord::Base
	
	belongs_to :city

end
