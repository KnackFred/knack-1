class FindProductParams
  attr_accessor :min_price
  attr_accessor :max_price
  attr_accessor :param
  attr_accessor :param_value
  attr_accessor :per_page
  attr_accessor :page
  attr_accessor :find_text
  attr_accessor :value_left
  attr_accessor :value_right

  def initialize(page = 1, per_page = 999999, param = nil, param_value = nil, min_price = 0, max_price = 0)
    self.page = page
    self.per_page = per_page
    self.param = param
    self.param_value = param_value
    self.min_price = min_price
    self.max_price = max_price
  end
end