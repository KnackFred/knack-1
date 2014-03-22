class Browsers
  attr_accessor :name
  attr_accessor :id
  attr_accessor :layout

  def initialize(id, name, layout)
    self.id = id
    self.name = name
    self.layout = layout
  end
end
