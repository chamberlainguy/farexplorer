# == Schema Information
#
# Table name: bfsessions
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bfsession < ActiveRecord::Base

	has_many :itins, dependent: :destroy
    has_many :legs, dependent: :destroy

end
