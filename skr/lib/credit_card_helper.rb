class CreditCardHelper
  CARDS = [
            {:id => 1, :Type => 'Visa', :alias => "visa"},
            {:id => 2, :Type => 'MasterCard', :alias => "master"},
            {:id => 3, :Type => 'Discover', :alias => "discover"},
            {:id => 4, :Type => 'Amex', :alias => "american_express"}
  ]
  
  attr_accessor :card_number, :exp_month, :exp_year, :first_name, :last_name, :verification, :card_type, :message
  
  def initialize(attributes = {})
    self.message = ''
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def get_card
    ActiveMerchant::Billing::CreditCard.new(
                                              :number => self.card_number,
                                              :month => self.exp_month,
                                              :year => self.exp_year,
                                              :first_name => self.first_name,
                                              :last_name => self.last_name,
                                              :verification_value  => self.verification,
                                              :type => CARDS.find {|p| p[:id] == self.card_type.to_i}[:alias]
                                            )
  end
  
  def card_valid?
    card = self.get_card
    unless ::APP_CONFIG['skip_credit_card_validation']
      unless card.valid?
        self.message = "Credit card not valid: " + card.validate.to_s
        return false
      end
    end

    true
  end
end
