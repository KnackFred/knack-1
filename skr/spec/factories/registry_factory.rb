FactoryGirl.define do

  factory :registry_item, :class => RegistryItem do |f|
    association :product
    association :registrant
    Contributed 0
    Purchased_ID RegistryItem::AVAILABLE
    Quantity 1
    Price 12
    IsDeleted false

    factory :registry_item_with_contributions, :class => RegistryItem do |f|
      ignore do
        contributed 10
      end

      after_build do |item, evaluator|
        contribution = Factory.build(:contribute, :Contribute => evaluator.contributed)
        item.contributes << contribution
        item.Contributed = evaluator.contributed
      end
    end

    factory :registry_item_purchased, :class => RegistryItem do |f|
      Purchased_ID RegistryItem::PURCHASED

      after_build do |item, evaluator|
        contribution = Factory.build(:contribute, :Contribute => item.total)
        item.contributes << contribution
        item.Contributed = item.total
      end
    end

    factory :registry_item_added_myself, :class => RegistryItem do |f|

      ignore do
        source_name nil
        source_url nil
      end

      after_build do |item, evaluator|
        item.product = Factory.build(:cash_product, :source_url => evaluator.source_url, :source_name => evaluator.source_name)
      end
    end

    factory :registry_item_external, :class => RegistryItem do |f|

      ignore do
        source_name "external site"
        source_url "www.yahoo.com"
        ext_color nil
        ext_size nil
        ext_other nil

      end

      after_build do |item, evaluator|
        item.product = Factory.build(:cash_product, :external => true, :source_url => evaluator.source_url, :source_name => evaluator.source_name, :ext_color => evaluator.ext_color, :ext_size => evaluator.ext_size, :ext_other => evaluator.ext_other )
      end
    end

    factory :registry_item_unique, :class => RegistryItem do |f|
      after_build do |item, evaluator|
        item.product = Factory.build(:product, :IsKind => true)
      end
    end

    factory :registry_item_cash, :class => RegistryItem do |f|
      after_build do |item, evaluator|
        item.product = Factory.build(:cash_product)
      end
    end
  end


  factory :contribute do |f|
    Contribute 99.99
    From "first name"
    Notes "Thanks a million"
  end
end
