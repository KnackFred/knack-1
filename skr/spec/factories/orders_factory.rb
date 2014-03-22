FactoryGirl.define do

  factory :orders2product do |f|
    association :product
    association :order
    Price 10
    Tax 10
    Shipment 10
    Quantity 1
  end

  factory :order do |f|
    amount 100
  end
end


Factory.define :withdrawal do |f|
  f.association :order
  f.association :registry_item
end

Factory.define :closed_payment do |f|
  f.association :order
  f.IsDeleted false
  f.typepayment_id Typepayment::CREDIT_CARD
  f.status_id 2
  f.amount 10
end

Factory.define :knack_payment do |f|
  f.association :orders2product
  f.association :partner
  f.Amount 10
end

Factory.define :orders_status do |f|
end

Factory.define :shipping_method, :class => Shippingmethod do |f|
  f.Price 0
end
