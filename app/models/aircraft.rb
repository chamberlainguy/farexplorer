# == Schema Information
#
# Table name: aircrafts
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  country_id :string
#

class Aircraft < ActiveRecord::Base
end
