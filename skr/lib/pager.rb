# To change this template, choose Tools | Templates
# and open the template in the editor.

class Pager
  
  attr_accessor :page_size
  attr_accessor :count_record
  attr_accessor :count_page
  attr_accessor :current_page
  attr_accessor :offset
  attr_accessor :left_pager
  attr_accessor :right_pager
  attr_accessor :prev_page
  attr_accessor :next_page

  def initialize(_page_size = 8, _count_record = 0, _current_page = 1)
    self.page_size = _page_size.blank? ? 8 : _page_size.to_i
    self.count_record = _count_record.to_i

    self.count_page = (self.count_record.to_f / self.page_size.to_f).ceil

    self.current_page = _current_page.blank? ? 1 : _current_page.to_i
    if self.current_page < 1
      self.current_page = 1
    else
      if self.current_page > self.count_page
        self.current_page = self.count_page
      end
    end

    self.offset = self.page_size * (self.current_page - 1)

    self.left_pager = Array.new
    self.right_pager = Array.new

    self.prev_page = self.current_page == 1 ? 1 : self.current_page - 1
    self.next_page = self.current_page == self.count_page ? self.count_page : self.current_page + 1

    if self.count_page <= 6
      1.upto(self.count_page) do |i|
        self.left_pager << i
      end
    else

      if self.current_page >= self.count_page - 5
        self.left_pager = Array.new
        (self.count_page - 5).upto(self.count_page-3) do |i|
          self.left_pager << i
        end
      else
        self.current_page.upto(self.current_page + 2) do |i|
          self.left_pager << i
        end
      end

      self.right_pager << self.count_page - 2
      self.right_pager << self.count_page - 1
      self.right_pager << self.count_page

    end
  end

  def self.array_mod(arr, mod, offset = 0)
    arr.shift(offset)
    out_arr = []

    arr.each_with_index do |val, idx|
      out_arr << val if idx % mod == 0
    end

    out_arr
  end

  def self.get_array(page_size, array, mod, offset)
    if array.length > 1
      array = array_mod(array, mod, offset)
      array = array.first(page_size)
    end

    return array
  end
end
