class Typepayment < ActiveRecord::Base
  has_many :orders, :foreign_key => "PaymentMethod_ID"
  has_many :closed_payments, :foreign_key => "typepayment_id"

  PAYPAL = 1
  CREDIT_CARD = 2
  CHECK = 3
  KNACK_CREDIT = 4

  TYPES = {PAYPAL => 'PayPal', CREDIT_CARD => 'CreditCard', CHECK => 'Check', KNACK_CREDIT => 'Knack reg.'}
end
