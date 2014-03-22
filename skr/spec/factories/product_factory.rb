FactoryGirl.define do
  factory :product_base, :class => Product do |p|
    sequence :Name do |n|
      "Test product #{n}"
    end
    Description "Test Product Description"
    MasterPrice 12.45
    SalesPrice 9.99
    Registrant_ID nil
    IsKind false
    IsKindView true
    ProductStatus_ID 1
    ShipmentType Product::FREE
    main_product_image File.open("public/images/apply.png")

    factory :product do

      after_build do |product, evaluator|
        if evaluator.categories.blank?
          product.categories << Category.root.children[0]
        else
          evaluator.categories.each do |cat|
            product.categories << cat
          end
        end

        if evaluator.stores.blank?
          product.stores = [Factory.build(:store)]
        else
          evaluator.stores.each do |store|
            product.stores << store
          end
        end

      end


      factory :product_with_params, :class => Product do |f|
        after_build do |o|
          o.product_params =
              [Factory.build(:product_param, :product => o)]
        end
      end

      factory :product_standard_shipping do
        ignore do
          per_shipment 10
        end

        ShipmentType Product::STANDARD

        after_build do |product, evaluator|

          product.shipment_category = product.categories[0]
          product.categories[0].per_shipment = evaluator.per_shipment
        end
      end

      factory :product_free_shipping do

      end

      factory :product_custom_shipping do
        ShipmentType Product::CUSTOM

        ShipmentCost 1
      end
    end
    factory :cash_product, :class => Product do |f|
      categories {[]}
      stores {[]}
      Registrant_ID 1
    end
  end

  factory :products2category do |p2c|
    category
    product
  end

  factory :products2store do |p2s|
    store
    product
  end

  factory :category do |f|
    sequence(:name) { |n| "Test category #{n}" }
    per_shipment 12.45
    parent_id {Category.root.id}
    visible true
  end

  factory :category_with_parent, :class => Category do |f|
    sequence(:name) { |n| "Test category #{n}" }
    per_shipment 12.45
    visible true
  end

end

Factory.define :product_status do |f|
  f.Name "Approved"
  f.Description "Test Product Description"
end

Factory.define :product_param do |f|
  f.association :partner
  f.association :product
  f.Name "Size"
  f.after_build do |o|
    o.value_params =
        [Factory.build(:value_param, :product_param => o),
         Factory.build(:value_param, :product_param => o),
         Factory.build(:value_param, :product_param => o)]
  end
end

Factory.define :product_params2order do |f|
  f.Name "Size"
  f.Value "Small"
end

Factory.define :value_param do |f|
  f.sequence(:Value) {|n| "value #{n}"}
end


Factory.define :brand do |f|
  f.sequence(:Name) { |n| "Test Brand#{n}" }
end

Factory.define :color do |f|
  f.sequence(:Name) { |n| "Color #{n}" }
  f.sequence(:RGB) { |n| n }
end

Factory.define :products2color do |f|
  f.association :product
  f.association :color
end

Factory.define :product_image do |f|
  f.association :product
  f.sequence(:ImageGUID) {|n| "GUID #{n}"}
  f.IsDeleted 0
  f.IsPDF 0
  f.IsVertical 1
end
Factory.define :commission do |f|

end