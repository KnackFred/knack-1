# To change this template, choose Tools | Templates
# and open the template in the editor.

class MathUtilite
  def initialize
    
  end

  ###################################
  # METHOD rounding to two decimal places
  ###################################
  def self.Round2(number)
    return (number * 100.0).ceil / 100.0
  end

  def self.Round4(number)
    return (number * 10000.0).ceil / 10000.0
  end

  def self.Round2Trim(number)
    n = Round2(number)
    (n % 1) > 0 ? n : n.to_i
  end

end
