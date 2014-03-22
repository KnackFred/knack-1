class ManageRegistryParams
  attr_accessor :sort
  attr_accessor :per_page
  attr_accessor :page
  attr_accessor :filter

  def initialize(page = 1, per_page = 9999999, sort = 0, filter = 0)
    self.page = page
    self.per_page = per_page
    self.sort = sort
    self.filter = filter
  end
end