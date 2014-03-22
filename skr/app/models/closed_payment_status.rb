class ClosedPaymentStatus < ActiveRecord::Base
  has_many :closed_payments, :foreign_key => "status_id"
end
