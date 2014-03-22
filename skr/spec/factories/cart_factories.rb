FactoryGirl.define do

  factory :buy_product, :class => BuyProduct do |f|
    id 100
    product_name "Product name"
    image_guid nil
    price 100
    color_id nil
    color_name ""
    category_id 10
    category_name "Category"
    quantity 1
    description "Description"
    tax 10
    shipment 20
    list_params []
    initialize_with { BuyProduct.new(:product => {:id => 1}) }
  end



  factory :buy_registry_item, :class => BuyRegistryItem do |f|
    id 100
    from "first last"
    notes "Your Welcome"
    product_name "Product name"
    type BuyRegistryItem::CONTRIBUTE
    image_guid nil
    color_id nil
    description "Description"
    price 10
    quantity 10
    subtotal 100
    tax 10
    shipment 1
    min_quantity 0.01
    max_quantity 10000
    min_contribution 100000
    max_contribution 10
    initialize_with { BuyRegistryItem.new(:test => true, :item => {:id => 1}) }

  end

end
