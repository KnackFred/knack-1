class Withdrawal < ActiveRecord::Base
  belongs_to :registrant, :foreign_key => "Registrant_ID"
  belongs_to :order,  :foreign_key => "Order_ID"
  has_many   :knack_payments, :foreign_key => "Withdrawal_ID"
  belongs_to :registry_item, :foreign_key => "registry_item_id"

  def net
    return self.Cash.to_f - self.Tax.to_f
  end

  def get_amount_knack_payment
    knack_amount = 0.0
    self.knack_payments.each do |payment|
      knack_amount += payment.Amount.to_f
    end

    return knack_amount
  end
end
