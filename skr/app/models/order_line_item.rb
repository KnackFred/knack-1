class OrderLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :registry_item

  after_create :update_registry_item

  def update_registry_item
    registry_item.increase_contributed(amount)
  end
end
