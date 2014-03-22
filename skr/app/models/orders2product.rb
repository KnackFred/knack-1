class Orders2product < ActiveRecord::Base
  belongs_to :product, :foreign_key => "Product_ID"
  belongs_to :order, :foreign_key => "Order_ID"
  has_many   :knack_payments, :foreign_key => "Order2Product_ID"
  belongs_to :color, :foreign_key => "Color_ID"
  has_many   :product_params2orders, :foreign_key => "Order2Product_ID"

  belongs_to :line_status, :foreign_key => "status_id"

  def total
    return self.subtotal + self.tax + self.shipment
  end

  def subtotal
    self.Price.to_f
  end

  def tax
    #MathUtilite.Round2(self.Tax.to_f * self.subtotal.to_f / 100)
    self.Tax.to_f
  end

  def shipment
    self.Shipment.to_f
    #self.Shipment.to_f *  self.Quantity.to_f
  end

  def price
    if self.Quantity == 0
      return 0
    else
      return MathUtilite.Round2(self.subtotal / self.Quantity)
    end
  end

  def knack_fee
    id = self.product.IsKind ? 3 : 2
    percent = Commission::COMMISSIONS.find{|x| x.id == id}.Percent
    MathUtilite.Round2(self.subtotal * percent / 100)
  end

  def net
    return self.total - self.knack_fee
  end

  def get_amount_knack_payment
    knack_amount = 0.0
    self.knack_payments.each do |payment|
      knack_amount += payment.Amount.to_f
    end

    return knack_amount
  end

  def self.get_registrant_orders2products(registrant_id)
    orders = Order.where(:registrant_id => registrant_id)

    o2ps = Array.new
    orders.each do |o|
      o2ps << o.orders2products
    end

    return o2ps
  end

  def cancel_line
    Orders2product.connection.transaction do
      self.update_attribute :status_id, 2

      if self.order.registrant_id.blank?
        type_payment = self.order.typepayment.blank? ? Typepayment::CREDIT_CARD : self.order.typepayment.id
      else
        type_payment = Typepayment::KNACK_CREDIT
      end



      closed_payment = ClosedPayment.new(:order_id => self.order.id,
                                         :typepayment_id => type_payment,
                                         :status_id => 1,
                                         :amount => self.total)

      begin
        closed_payment.save
      rescue
      end
    end

    MailUtilities.send_cancel_payment(self.order)
  end
end
