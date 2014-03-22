class Cart
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :registry_items, :products
  attr_accessor :withdraw_amount, :withdraw_ids
  attr_accessor :use_cash

  TYPE_BUY =        [BuyRegistryItem::ORDER,
                     BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY]

  TYPE_CONTRIBUTE = [BuyRegistryItem::CONTRIBUTE]
  #BuyRegistryItem::BUY_GIVER_2_REGISTRANT,
  #BuyRegistryItem::CONTRIBUTE_REGISTRANT,
  #BuyRegistryItem::BUY_REGISTRANT_NOT_FROM_REGISTRY]

  TYPE_WITHDRAW =   [BuyRegistryItem::EXCHANGE]

  def initialize(cart = nil)
    if cart.blank?
      self.registry_items = []
      self.products = []
      self.withdraw_amount = 0
      self.withdraw_ids = []
      self.use_cash = true
    else
      self.registry_items = cart.registry_items
      self.products = cart.products
      self.withdraw_amount = cart.withdraw_amount
      self.withdraw_ids = cart.withdraw_ids
      self.use_cash = cart.use_cash
    end
  end

  def persisted?
    false
  end

  ##################
  # Getting and setting the cart in the session.
  #####################
  # get cart
  def self.get_cart(session)
    cart = self.is_registrant?(session) ? session[:cart] : session[:giver]
    if cart.blank?
      cart = Cart.new
      self.set_cart(session, cart)
    end
    cart
  end

  # set cart
  def self.set_cart(session, cart)
    if self.is_registrant?(session)
      session[:cart] = cart
    else
      session[:giver] = cart
    end
  end

  # check role
  def self.is_registrant?(session)
    !session[:registrant].blank?
  end

  # clear session after success payment
  def self.clear_session(session)
    session[:cart] = nil
    session[:giver] = nil
    session[:order] = nil
    session[:payment_info] = nil
  end


  ###################################
  # Methods that determine what type of cart you have and if you are allowed to add certain items to the cart.
  #############################
  def self.is_withdraw?(cart)
    return cart.withdraw_amount && cart.withdraw_amount > 0
  end

  def self.is_buy?(cart)
    unless cart.registry_items.blank?
      if cart.registry_items.collect(&:type).count {|x| TYPE_BUY.include?(x)} > 0
        return true
      end
    end

    return !cart.products.blank?
  end

  def self.is_contribute?(cart)
    unless cart.registry_items.blank?
      if cart.registry_items.collect(&:type).count {|x| TYPE_CONTRIBUTE.include?(x)} > 0
        return true
      end
    end

    return false
  end

  def self.valid_cart_for_contribute?(session)
    cart = self.get_cart(session)
    !is_withdraw?(cart) && !is_buy?(cart)
  end

  def self.valid_cart_for_buy?(session)
    cart = self.get_cart(session)
    !is_withdraw?(cart) && !is_contribute?(cart)
  end

  def self.valid_cart_for_withdraw?(session)
    cart = self.get_cart(session)
    !is_buy?(cart) && is_contribute?(cart)
  end

  def self.is_empty_cart?(session)
    cart = self.get_cart(session)
    !is_buy?(cart) && !is_contribute?(cart) && !is_withdraw?(cart)
  end

  #######################
  #  Methods for adding items to the cart
  ######################

  # add item to cart
  def self.add_product_to_cart(session, item)
    cart = self.get_cart(session)
    cart.products = Array.new if cart.products.blank?
    cart.products << item

    #self.set_cart(session, cart)
    return true
  end

  # add registry item to cart
  def self.add_registry_item_to_cart(session, registry_item, type = nil)
    cart = self.get_cart(session)
    cart.registry_items = Array.new if cart.registry_items.nil?

    return false if self.registry_item_in_cart?(session, registry_item.id)

    cart.registry_items << registry_item

    #self.set_cart(session, cart)
    return true
  end

  # add item for withdrawal
  def self.add_item_for_withdrawal(session, item)
    cart = self.get_cart(session)

    return false if cart.withdraw_ids.include?(item.id)

    cart.withdraw_amount += item.Contributed
    cart.withdraw_ids << item.id

    #self.set_cart(session, cart)
    true
  end



  # check if a registry item is already in the cart
  def self.registry_item_in_cart?(session, id)
    cart = self.get_cart(session)

    return true if cart.withdraw_ids.include?(id.to_i)
    return false if cart.registry_items.blank?
    return cart.registry_items.collect(&:id).include?(id.to_i)
  end

  #######################
  #  Methods for modifying the cart
  ######################

  # update quantity item in cart
  def self.update_quantity_item(session, id, quantity)
    cart = self.get_cart(session)

    item = cart.products.find {|i| i.id.to_i == id.to_i}
    return false if item.blank?
    return false if quantity.to_i <= 0
    item.quantity = quantity
    true
  end


  def self.update_for_one_state(session, buyer_state_id)
    cart = self.get_cart(session)

    cart.registry_items.each do |item|
      registry_item = RegistryItem.find(item.id)
      item.tax = registry_item.product.tax(buyer_state_id) unless registry_item.product.cash?
    end

    cart.products.each do |item|
      product = Product.find(item.id)
      item.tax = product.tax(buyer_state_id)
    end
  end

  #######################
  #  Methods for removing items from the cart
  ######################
  # empty cart
  def self.empty_cart(session)
    self.clear_session(session)
    #self.set_cart(session, cart)
  end

  # delete registry item from cart
  def self.delete_registry_item_from_cart(session, id)
    cart = self.get_cart(session)
    cart.registry_items.delete_if {|x| x.id.to_i == id.to_i}
    #self.set_cart(session, cart)
  end

  # delete item from cart
  def self.delete_product_from_cart(session, id)
    cart = self.get_cart(session)
    cart.products.delete_if {|x| x.id.to_i == id.to_i}
    #self.set_cart(session, cart)
  end

  # delete cash
  def self.delete_cash(session)
    cart = get_cart(session)
    cart.withdraw_amount = 0
    cart.withdraw_ids = []
    #self.set_cart(session, cart)
  end

  def self.get_full_information(session)
    cart = self.get_cart(session)
    cart_information = CartInformation.new(:subtotal => 0,
                                           :tax_total => 0,
                                           :shipment_total => 0,
                                           :total => 0,
                                           :take => 0,
                                           :commission => 0,
                                           :withdraw_total => 0,
                                           :list_registry_items => Array.new,
                                           :list_products => Array.new)

    cart_information.use_cash = cart.use_cash

    # Get subtotal for registry items
    unless cart.registry_items.blank?
      cart_information.type = CartInformation::TYPE_BUY_CONTRIBUTE
      self.set_subtotal_for_items(cart_information, cart)
    end

    # Get Subtotal for products
    unless cart.products.blank?
      cart_information.type = CartInformation::TYPE_BUY_CONTRIBUTE
      set_subtotal_for_products(cart_information,cart)
    end

    cart_information.total = cart_information.subtotal + cart_information.tax_total + cart_information.shipment_total

    if self.is_registrant?(session)

      if self.is_withdraw?(cart)
        cart_information.type = CartInformation::TYPE_WITHDRAW
        set_subtotal_for_withdrawal(cart_information, cart)
      end

      registrant = Registrant.find(session[:registrant])
      cart_information.queue = registrant.get_queue_for_payment(cart)

      cart_information.missing_amount = cart_information.queue - cart_information.total
    end

    cart_information
  end

  private

  def self.set_subtotal_for_items(cart_information, cart)
    cart.registry_items.each do |registry_item|
      cart_information.tax_total += registry_item.tax_total
      cart_information.shipment_total += registry_item.shipment_total

      cart_information.list_registry_items << registry_item
      cart_information.subtotal += registry_item.subtotal

    end
  end

  def self.set_subtotal_for_products(cart_information, cart)
    cart.products.each do |item|
      cart_information.subtotal += item.subtotal
      cart_information.tax_total += item.tax_total
      cart_information.shipment_total += item.shipment_total
      cart_information.list_products << item
    end
  end

  def self.set_subtotal_for_withdrawal(cart_information, cart)
    cart_information.cash = nil
    cart_information.withdraw_total = cart.withdraw_amount

    percent = Commission::COMMISSIONS.find { |c| c.Name == 'WithDrawCash'}.Percent.to_f / 100.0
    cart_information.commission = MathUtilite.Round2(cart_information.withdraw_total) * percent

    cart_information.tax_total = MathUtilite.Round2(cart_information.commission)

    cart_information.total = cart_information.withdraw_total - cart_information.tax_total
  end

end
