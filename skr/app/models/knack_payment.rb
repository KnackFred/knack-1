class KnackPayment < ActiveRecord::Base
  belongs_to :withdrawal, :foreign_key => "Withdrawal_ID"
#  belongs_to :registry_item, :foreign_key => "Registrant2Product_ID"
  belongs_to :partner, :foreign_key => "Partner_ID"

  def order
  end

  def self.get_partner_payments(partner_id, o2pid = nil, o2r2pid = nil)
  end
end
