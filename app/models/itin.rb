# == Schema Information
#
# Table name: itins
#
#  id          :integer          not null, primary key
#  ticket_type :text
#  price       :decimal(, )
#  curr_code   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Itin < ActiveRecord::Base

	has_and_belongs_to_many :legs, dependent: :destroy
	belongs_to :bf_session

end
