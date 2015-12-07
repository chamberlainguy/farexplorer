# == Schema Information
#
# Table name: legs
#
#  id          :integer          not null, primary key
#  seq         :integer
#  search_key  :text
#  flight_mins :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Leg < ActiveRecord::Base

	has_and_belongs_to_many :itins
	has_many :segs, dependent: :destroy
	belongs_to :bf_session

end
