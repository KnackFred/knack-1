class FilterProduct
  attr_accessor :category_id
  attr_accessor :title
  attr_accessor :product_status_id
  attr_accessor :product_type_id
  attr_accessor :id
  attr_accessor :partner_id
  attr_accessor :store_id
  attr_accessor :page
  attr_accessor :per_page
  attr_accessor :sort_field
  attr_accessor :sort_direction
  
  SORT_DIRECTION = {"1" => ' ASC ', "2" => ' DESC '}

  def initialize(attributes = {})
     # default values
     self.category_id = Category.root.id
     self.title = ''
     self.product_status_id = 0
     self.product_type_id = "1"
     self.id = ''
     self.partner_id = 0
     self.store_id = 0
     self.page = 1
     self.per_page = 25
     self.sort_field = ''
     self.sort_direction = ''

     attributes.each do |name, value|
       send("#{name}=", value)
     end
   end
end
