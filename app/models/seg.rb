# == Schema Information
#
# Table name: segs
#
#  id                  :integer          not null, primary key
#  depart_datetime     :datetime
#  arrive_datetime     :datetime
#  stop_quantity       :integer
#  flight_num          :text
#  depart_airport_code :text
#  arrive_airport_code :text
#  flight_mins         :integer
#  mark_airline_code   :text
#  op_airline_code     :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Seg < ActiveRecord::Base

	belongs_to :leg

end
