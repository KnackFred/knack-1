class Contribute < ActiveRecord::Base
  belongs_to :registry_item, :foreign_key => 'registry_item_id', :inverse_of => :contributes
end
