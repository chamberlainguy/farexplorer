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

require 'test_helper'

class LegTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
