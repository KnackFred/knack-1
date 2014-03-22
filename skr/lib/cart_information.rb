class CartInformation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :type
  TYPE_BUY_CONTRIBUTE = 1
  TYPE_WITHDRAW = 3


  # Cost information when buying, contributing or ordering.
  attr_accessor :subtotal, :tax_total, :shipment_total
  # Withdrawal Amount information
  attr_accessor :withdraw_total, :commission
  attr_accessor :total

  # The items in the cart (Only for Buy/Contribute)
  attr_accessor :list_registry_items, :list_products

  #information about the registrants credit
  attr_accessor :queue, :missing_amount

  #use_cash
  attr_accessor :queue, :missing_amount

  # should the queue be used for this?.
  attr_accessor :use_cash

  # not sure.
  attr_accessor :take, :cash


  def initialize(attributes = {})
    self.missing_amount = 0
    self.queue
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def single_registrant?
    !list_registry_items.detect{|item| item.registrant != list_registry_items.first.registrant }
  end

  def registry_items_by_registrant
    {}.tap do |result|
      list_registry_items.each do |item|
        result[item.registrant] = [] unless result[item.registrant]
        result[item.registrant] << item
      end
    end
  end

  def registry_items_for(registrant)
    registry_items_by_registrant[registrant]
  end
end
