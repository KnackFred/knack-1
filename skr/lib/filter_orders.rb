# To change this template, choose Tools | Templates
# and open the template in the editor.

class FilterOrders
  attr_accessor :customer
  attr_accessor :order_id
  attr_accessor :datepicker_from
  attr_accessor :datepicker_to
  attr_accessor :store_id
  attr_accessor :status_id
  attr_accessor :gross_from
  attr_accessor :gross_to
  attr_accessor :paid_full
  attr_accessor :type_order

  def initialize
    self.customer = ''
    self.order_id = ''
    self.store_id = 0
    self.status_id = 0
    self.datepicker_from = ''
    self.datepicker_to = ''
    self.gross_from = ''
    self.gross_to = ''
    self.paid_full = 0
    self.type_order = 0
  end

  def filter(orders, partner_id = nil)
    if self.paid_full.to_i == 1
      if partner_id.blank?
        orders = orders.find_all{ |p| p.get_net().to_f <= p.get_knack_payments().to_f}
      else
        orders = orders.find_all{ |p| p.get_partner_net(partner_id).to_f <= p.get_knack_payment(partner_id).to_f}
      end
      
    end

    unless self.type_order == 0
      orders = orders.find_all { |x| x.order_type == self.type_order.to_i }
    end

    unless self.customer == ''
      names = self.customer.split(' ')
      if names.length == 1
        names << names[0]
      end

      orders = orders.find_all{ |p|
        if !p.BillingFirstName.blank? && !p.BillingLastName.blank?
        (p.BillingFirstName.upcase.include? names[0].upcase) ||
          (p.BillingFirstName.upcase.include? names[1].upcase) ||
          (p.BillingLastName.upcase.include? names[0].upcase) ||
          (p.BillingLastName.upcase.include? names[1].upcase)
        end
       }
    end

    orders = orders.find_all{ |p| p.id.to_i == self.order_id.to_i} unless self.order_id == ''

    unless self.store_id.to_i == 0
      orders = orders.find_all do |x|
        (x.get_products.find_all { |p| p.get_default_store.id.to_i == self.store_id.to_i }).length > 0
        #x.orders2products.products.find_all { |y| y.get_default_store.id.to_i == self.store_id }.length != 0 || x.orders2registry_items.registrant2product.products.find_all { |y| y.get_default_store.id.to_i == self.store_id }.length != 0
      end
    end

    unless self.status_id == 0
      orders = orders.find_all { |p| p.OrdersStatus_ID == self.status_id  }
    end

    

    unless self.datepicker_from == ''
      orders = orders.find_all{ |p| Date.parse(p.DateTime.to_s) >= Date.parse(self.datepicker_from) }
    end

    unless self.datepicker_to == ''
      orders = orders.find_all{ |p| Date.parse(p.DateTime.to_s) <= Date.parse(self.datepicker_to) }
    end

    unless self.gross_from == ''
      unless partner_id.blank?
        orders = orders.find_all{ |p| p.get_partner_gross(partner_id) >= self.gross_from.to_f }
      else
        orders = orders.find_all{ |p| p.Amount >= self.gross_from.to_f }
      end
    end

    unless self.gross_to == ''
      unless partner_id.blank?
        orders = orders.find_all{ |p| p.get_partner_gross(partner_id) <= self.gross_to.to_f }
      else
        orders = orders.find_all{ |p| p.Amount <= self.gross_to.to_f }
      end
    end

    orders
  end
end
