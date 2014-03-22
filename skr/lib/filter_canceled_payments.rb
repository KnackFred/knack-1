# To change this template, choose Tools | Templates
# and open the template in the editor.

class FilterCanceledPayments
  attr_accessor :customer
  attr_accessor :order_id
  attr_accessor :datepicker_from
  attr_accessor :datepicker_to
  attr_accessor :status_id
  attr_accessor :type_payment

  def initialize
    self.customer = ''
    self.order_id = ''
    self.status_id = 0
    self.datepicker_from = ''
    self.datepicker_to = ''
    self.type_payment = 0
  end

  def filter(payments)
    unless self.type_payment == 0
      payments = payments.find_all { |x| x.typepayment.id.to_i == self.type_payment.to_i }
    end

    unless self.customer == ''
      names = self.customer.split(' ')
      if names.length == 1
        names << names[0]
      end

      payments = payments.find_all {|payment|
        if !payment.order.BillingFirstName.blank? && !payment.order.BillingLastName.blank?
        (payment.order.BillingFirstName.upcase.include? names[0].upcase) ||
          (payment.order.BillingFirstName.upcase.include? names[1].upcase) ||
          (payment.order.BillingLastName.upcase.include? names[0].upcase) ||
          (payment.order.BillingLastName.upcase.include? names[1].upcase)
        end
      }
    end

    payments = payments.find_all{ |p| p.id.to_i == self.order_id.to_i} unless self.order_id == ''

    unless self.status_id == 0
      payments = payments.find_all { |p| p.status_id == self.status_id  }
    end



    unless self.datepicker_from == ''
      payments = payments.find_all{ |p| Date.parse(p.order.DateTime.to_s) >= Date.parse(self.datepicker_from) }
    end

    unless self.datepicker_to == ''
      payments = payments.find_all{ |p| Date.parse(p.order.DateTime.to_s) <= Date.parse(self.datepicker_to) }
    end

    payments
  end
end
