class PaymentInfo
  attr_accessor :card_number 
  attr_accessor :card_verification
  attr_accessor :card_type
  attr_accessor :card_exp_month
  attr_accessor :card_exp_year
  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :paypal_email
  attr_accessor :type_payment

  attr_accessor :use_cash #Indicates if the users queue should be used.

  CASH = 0
  CREDIT_CARD = 1
  BUY_PAYPAL = 2
  WITHDRAW_PAYPAL = 3
  CHECK = 4

  TYPE_PAYMENT = {0 => "cash", 1 => "credit card", 2 => "buy paypal", 3 => "withdraw paypal", 4 => "check"}

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
