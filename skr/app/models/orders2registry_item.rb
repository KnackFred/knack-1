class Orders2registryItem < ActiveRecord::Base
  belongs_to :registry_item, :foreign_key => "registry_item_id"
  belongs_to :order, :foreign_key => "Order_ID", :inverse_of => :orders2registry_items
  has_many :knack_payments, :foreign_key => "order2registry_item_id"
  has_many :product_params2orders, :through => :registry_item

  belongs_to :contribute, :foreign_key => "Contribute_ID", :dependent => :destroy
  belongs_to :line_status, :foreign_key => "status_id"

  def knack_fee
    return self.registry_item.knack_fee(self.IsGetMoney)
  end

  def total
    self.registry_item.total
  end

  def subtotal
    self.registry_item.subtotal
  end

  def tax
    self.registry_item.tax_total
  end

  def shipment
    self.registry_item.shipment_total
  end

  def price
    self.registry_item.Price.to_f
  end

  def quantity
    self.registry_item.Quantity.to_f
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

  def name
    self.registry_item.product.Name
  end

  def self.get_registrant_contributes(registrant_id)
    Orders2registryItem.joins(:registry_item).where(:registry_item => {:Registrant_ID => registrant_id}).where("contribute_id IS NOT NULL")
  end

  def self.get_contributes_by_order(order_id)
    o2r2p = Orders2registryItem.find(:all, :conditions => ["Contribute_ID IS NOT NULL AND Order_ID = ?", order_id])
    return o2r2p
  end

   def cancel_line
     Orders2registryItem.connection.transaction do
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
