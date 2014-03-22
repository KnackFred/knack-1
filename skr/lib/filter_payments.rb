# To change this template, choose Tools | Templates
# and open the template in the editor.

class FilterPayments
  attr_accessor :payment_id
  attr_accessor :datepicker_from
  attr_accessor :datepicker_to
  attr_accessor :status_id
  attr_accessor :payment_amount_from
  attr_accessor :payment_amount_to

  def initialize
    self.payment_id = ''
    self.status_id = 0
    self.datepicker_from = ''
    self.datepicker_to = ''
    self.payment_amount_from = ''
    self.payment_amount_to = ''
  end

  def filter(payments, partner_id = nil)

    payments = (payments.sort_by { |e| e.id.to_i }).reverse

    payments = payments.find_all do |p|
      p.id.to_i == self.payment_id.to_i
    end unless self.payment_id == ''

#    unless self.status_id == 0
#      payments = payments.find_all { |p| p.OrdersStatus_ID == self.status_id  }
#    end

    unless self.datepicker_from == ''
      payments = payments.find_all{ |p| Date.parse(p.DateTime.to_s) >= Date.parse(self.datepicker_from) }
    end

    unless self.datepicker_to == ''
      payments = payments.find_all{ |p| Date.parse(p.DateTime.to_s) <= Date.parse(self.datepicker_to) }
    end

    unless self.payment_amount_from == ''
        payments = payments.find_all{ |p| p.Amount.to_f >= self.payment_amount_from.to_f }
    end

    unless self.payment_amount_to == ''
        payments = payments.find_all{ |p| p.Amount.to_f <= self.payment_amount_to.to_f }
    end

    payments
  end

  def pager(array, offset, page_size)
    array = Pager.get_array(page_size, array, 1, offset)
    return array
  end
end
