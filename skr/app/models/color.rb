class Color < ActiveRecord::Base
  has_many :products2colors, :foreign_key => "Color_ID"
  has_many :products, :through => :products2colors

  has_one :registry_item, :foreign_key => "Color_ID"

  validates :Name,      :presence => true,
                        :length => {:minimum => 0, :maximum => 50},
                        :uniqueness => {:message => "This color is already exist", :case_sensitive => false}

  validates :RGB,       :presence => true,
                        :length => {:minimum => 0, :maximum => 6},
                        :uniqueness => {:message => "This color is already exist", :case_sensitive => false}
end
