class State < ActiveRecord::Base
  has_many :stores
  has_many :registrants


  validates_presence_of :Name, :GeneralTax
  validates_numericality_of :GeneralTax
  validates_uniqueness_of :Name

end
