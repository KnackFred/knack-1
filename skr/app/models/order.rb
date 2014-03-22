class Order < ActiveRecord::Base
  has_many :order_line_items, :dependent => :destroy, :inverse_of => :order
  has_many :registry_items, :through => :order_line_items
  belongs_to :registrant

  def self.create_order(registrant, buy_registry_items)
    Order.create(:registrant => registrant).tap do |order|
      buy_registry_items.each do |buy_item|
        order.order_line_items.create(:registry_item_id => buy_item.id, :amount => buy_item.contribute, :quantity => buy_item.quantity, :from => buy_item.from, :notes => buy_item.notes)
      end
      order.save
    end
  end

  def amount
    order_line_items.tap(&:amount).sum
  end
end
