# == Schema Information
#
# Table name: taxes
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  country_id :string
#

class Tax < ActiveRecord::Base
end
