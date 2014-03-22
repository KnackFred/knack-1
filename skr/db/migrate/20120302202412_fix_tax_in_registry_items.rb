class FixTaxInRegistryItems < ActiveRecord::Migration
  class Registry_Item <ActiveRecord::Base
    belongs_to :product, :foreign_key => "Product_ID"
  end

  def self.Round2(number)
    return (number * 100.0).ceil / 100.0
  end


  def self.up
    RegistryItem.all.each do |item|
      if (item.product.Registrant_ID.nil? || item.IsToolbar) && item.Purchased_ID == 2 #  Only Available items added with the bookmarklet tool
        if item.Price == 0 || item.Tax == 0
          new_tax = 0.0
        else
          new_tax = self.Round2((item.Tax.to_f / item.Price) * 100.0)
        end
        item.update_attribute(:Tax, new_tax)
      end
    end
  end

  def self.down
    RegistryItem.all.each do |item|
      if (item.product.Registrant_ID.nil? || item.IsToolbar) && item.Purchased_ID == 2 #  Only Available items added with the bookmarklet tool
        old_tax = self.Round2(item.Price.to_f * (item.Tax.to_f / 100.0))
        item.update_attribute(:Tax, old_tax)
      end
    end
  end
end
