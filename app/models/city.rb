# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  country_id :string
#

class City < ActiveRecord::Base

	has_many :airports
	belongs_to :country

end
