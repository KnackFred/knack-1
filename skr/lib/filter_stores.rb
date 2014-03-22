# To change this template, choose Tools | Templates
# and open the template in the editor.

class FilterStores
  attr_accessor :city
  attr_accessor :name
  attr_accessor :partner
  attr_accessor :id

  def initialize
    self.city = ''
    self.name = ''
    self.partner = ''
    self.id = ''
  end

  def filter()
    stores = Store.find(:all).reverse

    unless self.id.to_s == ''
      stores = stores.find_all {|s| s.id.to_s == self.id.to_s}
    end

    unless self.partner == ''
      names = self.partner.split(' ')
      if names.length == 1
        names << names[0]
      end

      stores = stores.find_all{ |s|
        if !s.partner.BillingName.blank? && !s.partner.BillingLastName.blank?
        (s.partner.BillingName.upcase.include? names[0].upcase) ||
          (s.partner.BillingName.upcase.include? names[1].upcase) ||
          (s.partner.BillingLastName.upcase.include? names[0].upcase) ||
          (s.partner.BillingLastName.upcase.include? names[1].upcase)
        end
       }
    end

    unless self.name == ''
      stores = stores.find_all{ |s| s.Name.upcase.include? self.name.upcase}
    end

    unless self.city == ''
      stores = stores.find_all{ |s| s.City.upcase.include? self.city.upcase}
    end

    stores
  end
end
