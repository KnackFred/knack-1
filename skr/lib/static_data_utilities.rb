# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'open-uri'
class StaticDataUtilities
  def initialize
    
  end

  def self.get_states (include_select = true)
    states = Array.new
    if include_select
      states << State.new do |p|
        p.id = 0
        p.Name = "Select a State"
      end
    end
    states + State.all
  end

  def self.get_registrant_type
    types = Array.new
    types << RegistrantType.new(:id => 0, :Name => "Select registry type")
    #types[0].id = 0
    return types + RegistrantType.all
  end

  def self.get_order_type_select
    types = Array.new
    types << ["Select type", 0]
    Order::TYPES.each { |key,value|
      types << [value, key]
    }
    types
  end

  def self.get_types_payments
    types = Array.new
    types << Typepayment.new(:id => 0, :Name => "Select type")
    #types[0].id = 0
    return types + Typepayment.all
  end

  def self.get_categories
    categories = Array.new
    categories << Category.new(:id => 0, :name => "All")
    return categories + Category.where("id != ?", Category.root.id)
  end

  def self.get_stores_select()
    stores = Array.new
    stores << Store.new(:id => 0, :Name => "Select store")
    #stores[0].id = 0
    return stores + Store.select("id, Name").all
  end

  def self.get_product_params_select()
    params = Array.new
    params << ProductParam.new(:id => 0, :Name => "Empty")
    return params + ProductParam.where(:IsTemplate => true)
  end

  def self.get_partner_product_params_select(partner_id)
    params = Array.new
    params << ProductParam.new(:id => 0, :Name => "Empty")
    return params + ProductParam.where(:Partner_ID => partner_id, :IsTemplate => true)
  end

  def self.get_stores_by_partner_select(partner_id)
    stores = Array.new
    stores << Store.new(:id => 0, :Name => "Select store")
    #stores[0].id = 0
    return stores + Store.where(:PartnerID => partner_id)
  end


  def self.get_product_status
    statuses = Array.new
    statuses << ProductStatus.new do |p|
      p.id = 0
      p.Name = "All"
    end
    ProductStatus::STATUSES.each { |key,value|
      statuses << ProductStatus.new do |p|
        p.id = key
        p.Name = value
      end
    }
    statuses    
  end

  def self.get_product_status_select
    statuses = Array.new
    ProductStatus::STATUSES.each { |key,value|
      statuses << ProductStatus.new do |p|
        p.id = key
        p.Name = value
      end
    }
    statuses
  end
  

  def self.get_brands_select
    brands = Array.new
    brands << Brand.new(:id => 0, :Name => "Select brand")
    #brands[0].id = 0
    return brands + Brand.all
  end


  def self.get_sort_params
    sort_params = Array.new
    sort_params << SortProducts.new(0, "-")
    sort_params << SortProducts.new(1, "Low-High")
    sort_params << SortProducts.new(2, "High-Low")
    return sort_params
  end

  def self.get_status_accounts
    status = Array.new
    status << SortProducts.new(0, "Select")
    status << SortProducts.new(1, "Active")
    status << SortProducts.new(2, "Closed")
    return status
  end
  
  def self.get_list_order_status
    statuses = Array.new
    OrdersStatus::STATUSES.each { |key,value|
      statuses << OrdersStatus.new do |p|
        p.id = key
        p.Name = value
      end
    }
    statuses
  end

  def self.get_order_status
    statuses = Array.new
    statuses << OrdersStatus.new do |p|
      p.id = 0
      p.Name = "All"
    end
    OrdersStatus::STATUSES.each { |key,value|
      statuses << OrdersStatus.new do |p|
        p.id = key
        p.Name = value
      end
    }
    statuses
  end

  def self.get_order_status_select
    statuses = Array.new
    statuses << OrdersStatus.new do |p|
      p.id = 0
      p.Name = "Select status"
    end
    OrdersStatus::STATUSES.each { |key,value|
      statuses << OrdersStatus.new do |p|
        p.id = key
        p.Name = value
      end
    }
    statuses
  end

  def self.get_closed_payment_status_select
    statuses = Array.new
    statuses << ClosedPaymentStatus.new(:id => 0, :Name => "Select")
    #statuses[0].id = 0
    return statuses + ClosedPaymentStatus.all
  end

  def self.reset_default_store(partner_id, store_id = 0)
    stores = Store.where(:PartnerID => partner_id)
    stores.each do |s|
      unless s.id == store_id
        s.update_attribute(:IsDefault, 0)
      end
    end
  end

  def self.get_shipping_method_select
    methods = Array.new
    methods << Shippingmethod.new(:id => 0, :Name => "Select")
    #methods[0].id = 0
    return methods + Shippingmethod.all
  end

  def self.get_prepare_error_message
    return '<img src="/images/error.gif"/>  '.html_safe
  end
end
