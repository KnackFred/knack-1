# To change this template, choose Tools | Templates
# and open the template in the editor.

class Json_search
  attr_accessor :query
  attr_accessor :suggestions
  attr_accessor :data

  def initialize
    self.query = ''
    self.suggestions = Array.new
    self.data = Array.new
  end
end
