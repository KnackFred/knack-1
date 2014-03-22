# To change this template, choose Tools | Templates
# and open the template in the editor.

class SortOrders

  attr_accessor :id
  attr_accessor :Name

  attr_accessor :date
  attr_accessor :amount

  def initialize(_id = 0, _name = '')
    self.id = _id
    self.Name = _name

    self.date = 0
    self.amount = 0
    
  end

  def sort(array, offset, page_size)
    #------------------------------
    #- Sort by datetime
    #------------------------------
    if self.date == 1
      array = array.sort_by { |p| Date.parse(p.DateTime.to_s) }
    else
      if self.date == "2"
        array = array.sort { |a,b| Date.parse(b.DateTime.to_s) <=> Date.parse(a.DateTime.to_s) }
      end
    end

    #------------------------------
    #- Sort by amount
    #------------------------------
    if self.amount == 1
      array = array.sort_by { |p| p.Amount }
    else
      if self.amount == 2
        array = array.sort { |a,b| b.Amount <=> a.Amount }
      end
    end

    array = Pager.get_array(page_size, array, 1, offset)
    return array
  end
end
