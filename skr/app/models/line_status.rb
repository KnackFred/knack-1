class LineStatus < ActiveRecord::Base
  has_many :orders2products, :foreign_key => "status_id"
  has_many :orders2registry_items, :foreign_key => "status_id"
end
