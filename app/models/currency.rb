# == Schema Information
#
# Table name: currencies
#
#  id       :integer          not null, primary key
#  country  :string
#  currency :string
#  code     :string
#  symbol   :string
#

class Currency < ActiveRecord::Base
end
