# To change this template, choose Tools | Templates
# and open the template in the editor.

class Ordered
  attr_accessor :image_url
  attr_accessor :name
  attr_accessor :date_time
  attr_accessor :delivery_date

  attr_accessor :get_money
  attr_accessor :knack_fee

  attr_accessor :quantity
  attr_accessor :price
  attr_accessor :total

  attr_accessor :order_number

  attr_accessor :type

  attr_accessor :product_id

  attr_accessor :registry_item

  def initialize

  end

  def self.get_ordered(orders)
    ordereds = Array.new

    orders.each do |order|
      if order.order_type == Order::BUY
        order.orders2products.each do |o|
          ordered = Ordered.new
          ordered.image_url = o.product.main_product_thumb.url(:medium)
          ordered.product_id = o.product.id
          ordered.name = o.product.Name
          ordered.quantity = o.Quantity
          ordered.price = o.price.to_f
          ordered.total = o.total.to_f
          ordered.date_time = o.order.DateTime
          ordered.delivery_date = o.order.DeliveryDate
          ordered.order_number = o.order.id
          ordered.type = 1

          ordereds << ordered
        end

        order.orders2registry_items.each do |o|
          ordered = Ordered.new
          ordered.image_url = o.registry_item.product.main_product_thumb.url(:medium)
          ordered.product_id = o.registry_item.product.id
          ordered.name = o.registry_item.product.Name
          ordered.date_time = o.order.DateTime
          ordered.delivery_date = o.order.DeliveryDate
          ordered.registry_item = o.registry_item

          if o.IsGetMoney
            ordered.get_money = o.registry_item.Contributed.to_f
            ordered.type = 3
          else
            ordered.quantity = o.registry_item.Quantity
            ordered.price = o.registry_item.Price.to_f
            ordered.total = o.total.to_f
            ordered.order_number = o.order.id
            ordered.type = 1
          end

          ordereds << ordered
        end
      end

      if order.order_type == Order::WITHDRAW
        order.withdrawals.each do |o|
          ordered = Ordered.new
          if o.registry_item_id.blank?
            ordered.image_url = "/images/cash.png"
            ordered.name = "Cash"
          else
            ordered.image_url = o.registry_item.product.main_product_thumb.url(:medium)
            ordered.product_id = o.registry_item.product.id
            ordered.registry_item = o.registry_item
            ordered.name = o.registry_item.product.Name
          end

          
          ordered.date_time = o.order.DateTime
          ordered.delivery_date = o.order.DeliveryDate
          ordered.order_number = o.order.id
          ordered.get_money = o.Cash.to_f - o.Tax.to_f
          ordered.knack_fee = o.Tax.to_f
          ordered.type = 2

          ordereds << ordered
        end
      end
    end

    return ordereds
  end
end
