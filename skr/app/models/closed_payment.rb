class ClosedPayment < ActiveRecord::Base
  belongs_to :closed_payment_status, :foreign_key => "status_id"
  belongs_to :order, :foreign_key => "order_id"
  belongs_to :typepayment, :foreign_key => "typepayment_id"
end
