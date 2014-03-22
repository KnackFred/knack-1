class Commission < ActiveRecord::Base
  validates_uniqueness_of :Name, :case_sensitive => false
  COMMISSIONS = [
            Commission.new do |c|
              c.id = 1
              c.Name = 'WithDrawCash'
              c.Percent = 5.0
            end,
            Commission.new do |c|
              c.id = 2
              c.Name = 'Knack Fee'
              c.Percent = 10.0
            end,
            Commission.new do |c|
              c.id = 3
              c.Name = 'Knack Fee where Kind'
              c.Percent = 15.0
            end
  ]
end
