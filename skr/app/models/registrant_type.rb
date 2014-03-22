class RegistrantType < ActiveRecord::Base
  validates_uniqueness_of :Name
end
