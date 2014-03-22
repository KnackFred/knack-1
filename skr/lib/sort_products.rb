class SortProducts

  attr_accessor :id
  attr_accessor :Name

  attr_accessor :selected
  attr_accessor :purchased
  attr_accessor :price
  attr_accessor :ordered

  def initialize(_id = 0, _name = '')
    self.id = _id
    self.Name = _name

    self.ordered = 0
    self.selected = 0
    self.purchased = 0
    self.price = 0
  end
end
