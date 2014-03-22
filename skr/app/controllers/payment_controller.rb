class PaymentController < ApplicationController
  skip_before_filter :check_out, [:select_payment_method, :pay_via_check, :pay_via_venmo]
  skip_before_filter :full_nav, [:select_payment_method, :pay_via_check, :pay_via_venmo]
  before_filter :create_venmo

  #######################################################
  # Action CART
  #######################################################
  def cart
    if request.post?
      if params[:quantityId].blank?
        redirect_to select_payment_method_path
        return
      end
    end

    unless params[:quantityId].blank? || params[:quantityValue].blank?
      quantity = (params[:quantityValue].to_i >= 1) ? params[:quantityValue].to_i : 1
      Cart.update_quantity_item(session, params[:quantityId], quantity)
    end

    @cart_information = Cart.get_full_information(session)
  end

  #######################################################
  # Action DELETE REGISTRY ITEM FROM CART
  #######################################################
  def deletefromcart
    unless params[:id].blank?
      Cart.delete_registry_item_from_cart(session, params[:id])
    end
    redirect_to cart_path
  end

  #######################################################
  # Action DELETE ITEM FROM CART
  #######################################################
  def deletefrombuycart
    unless params[:id].blank?
      Cart.delete_product_from_cart(session, params[:id])
    end
    redirect_to cart_path
  end

  #######################################################
  # Action DELETE CASH
  #######################################################
  def deletecash
    Cart.delete_cash(session)
    redirect_to cart_path
  end

  #######################################################
  # Action EMPTY CART
  #######################################################
  def emptycart
    Cart.empty_cart(session)
    redirect_to cart_path
  end

  def pay_via_venmo
    @cart_information = Cart.get_full_information(session)
    @venmo.store_access_token(params[:access_token])
  end

  def make_payment_via_venmo
    registrant = Registrant.find(params[:registrant_id])
    @cart_information = Cart.get_full_information(session)
    begin
      RegistryItem.transaction do
        registry_items = @cart_information.registry_items_for(registrant)
        order = Order.create_order(registrant, registry_items)
        @venmo.make_payment(params[:amount], registrant.Email, registrant.display_name) if Rails.env != 'development' || Rails.env != 'test'
        registry_items.each do |item|
          Cart.delete_registry_item_from_cart(session, item.id)
        end
      end
    rescue VenmoError => e
      flash[:error] = e.message
    end
    if Cart.is_empty_cart?(session)
      redirect_to root_path
    else
      redirect_to :back
    end
  end

  ##############################################################
  # ACTION error payment
  ##############################################################
  def error_payment
    notify_airbrake("Error in Payment " + params[:message])
    @result = params[:message]
  end

  ##############################################################
  # ACTION payment_interrupted
  ##############################################################
  def payment_interrupted
    @result = params[:message]
    render :error_payment
  end


  ##############################################################
  # ACTION success payment
  ##############################################################
  def success_payment
    #---------------------
    #- Checking for the existence of an order
    #---------------------
    if session[:order].blank? || params[:guid].blank?
      redirect_to payment_interrupted_path(:message => "The page was refreshed while your order was being processed. Please wait a few minutes and then check your email for an order confirmation.  If you did not receive a confirmation email please contact support@knackregistry.com")
      return
    else
      order = session[:order]
      unless order.GUID == params[:guid]
        redirect_to error_payment_path("Invalid in success_payment")
        return
      end
    end

    # set status and date
    order.OrdersStatus_ID = OrdersStatus::STATUSES.invert['New']
    order.DateTime = DateTime.now

    # get information about order
    cart = Cart.get_cart(session)
    cart_information = Cart.get_full_information(session)
    payment_info = session[:payment_info]

    if session[:registrant].blank? # how not authenticated user
      order.save

      # BUY A PRODUCT FOR A NON AUTHENTICATED USER
      cart.products.each do |item|
        unless order.buy_item_himself(item)
          redirect_to error_payment_path(ErrorMessages.get_text_error(0))
          return
        else
          expire_brands_cache if Product.find_by_id(item.id).IsKind
        end
      end

      # CONTRIBUTE TO A REGISTRY GIFT
      cart.registry_items.each do |item|
        unless order.buy_item_someone(item)
          redirect_to error_payment_path(ErrorMessages.get_text_error(0))
          return
        end
      end
    else # authorized user
      order.registrant_id = registrant.id
      order.save

      cart.registry_items.each do |item|
        # Get money from queue
        if payment_info.use_cash
          if item.total > RegistryItem.find_by_id(item.id).Contributed
            unless order.use_cash_money(item, registrant, 'registry item')
              redirect_to error_payment_path(ErrorMessages.get_text_error(0))
              return
            end
          end
        else
          if item.type == BuyRegistryItem::ORDER || item.type == BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY
            registrant.update_attribute(:Cash, registrant.Cash.to_f + RegistryItem.find_by_id(item.id).Contributed)
          end
        end

        case item.type
        when BuyRegistryItem::ORDER
          unless order.buy_from_registry(item)
            redirect_to error_payment_path(ErrorMessages.get_text_error(0))
            return
          end
        when BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY
          unless order.buy_from_registry(item)
            redirect_to error_payment_path(ErrorMessages.get_text_error(0))
            return
          end
        when BuyRegistryItem::CONTRIBUTE
          unless order.buy_item_someone(item)
            redirect_to error_payment_path(ErrorMessages.get_text_error(0))
            return
          end
        end
      end

      # BUY FOR HIMSELF
      cart.products.each do |item|
        # Get money from queue
        if payment_info.use_cash
          unless order.use_cash_money(item, registrant, 'product')
            redirect_to error_payment_path(ErrorMessages.get_text_error(0))
            return
          end
        end

        # BUY FOR HIMSELF
        unless order.buy_item_himself(item)
          redirect_to error_payment_path(ErrorMessages.get_text_error(0))
          return
        else
          expire_brands_cache if Product.find_by_id(item.id).IsKind
        end
      end

      # GET CASH
      if cart_information.type == CartInformation::TYPE_WITHDRAW
        # UPDATE RECORD ABOUT PRODUCT IN REGISTRY ITEM
        # For each item being exchanged for cash
        cart.withdraw_ids.each do |id|
          unless order.exchange(id)
            redirect_to error_payment_path(ErrorMessages.get_text_error(0))
            return
          end
        end

        # We do not allow users to withdraw from credit at the moment, but this is going to come up, and will need to be added back in.
        # If the user has decided to withdraw some cash.
        #if cart.Cash.IsCash
        #  unless order.withdraw_from_cash(registrant)
        #    redirect_to error_payment_path(ErrorMessages.get_text_error(0))
        #    return
        #  end
        #end
      end
    end

    # Clear out payment_info and the cart
    Cart.clear_session(session)
    # Send an email confirming the order
    MailUtilities.send_order(order) unless cart_information.type == CartInformation::TYPE_WITHDRAW
    @transaction = Transactions.get_transaction(order)

    unless registrant.blank?
      @queue = registrant.get_queue
    end
  end

  ##############################################################
  # ACTION process_order
  ##############################################################
  def process_order
    if Cart.is_empty_cart?(session)
      redirect_to cart_path
      return
    end

    if session[:order].blank?   # Get the order, or error out if it's not set.
      redirect_to cart_path
      return
    else
      order = session[:order]
    end

    @cart_information = Cart.get_full_information(session)
    @payment_info = session[:payment_info]

    if session[:registrant].blank? # If this is not a logged in user,
      amount = @cart_information.total
    else                          # If this is a registered user.
      if @payment_info.use_cash
        amount = @cart_information.queue > @cart_information.total ? 0 : @cart_information.total - @cart_information.queue
      else
        amount = @cart_information.total
      end

      session[:order].TakeMoneyAmount = @cart_information.total - amount
    end

    # At this point.
    # cart has been set.
    # amount has been set to the total amount minus any money being taken from credit.
    # Sub-totals have ben set for tax and shiping etc...
    # TakeAmountMoney in the order in the session has been set to the amount taken from credit.

    amount *=  100

    case @payment_info.type_payment
    when PaymentInfo::TYPE_PAYMENT.invert['cash']
      redirect_to success_payment_path(order.GUID)
    when PaymentInfo::TYPE_PAYMENT.invert['credit card']
      begin
        card = ActiveMerchant::Billing::CreditCard.new(
          :number => @payment_info.card_number,
          :month => @payment_info.card_exp_month,
          :year => @payment_info.card_exp_year,
          :first_name => @payment_info.first_name,
          :last_name => @payment_info.last_name,
          :verification_value  => @payment_info.card_verification,
          :type => @payment_info.card_type
        )
        @result = process_payment(card, amount, order)

        unless @result.include?("Success")
          redirect_to step3_path, :alert => "There was an issue processing your payment.  Please check the information you provided and try again.<br/><br/>" + @result
        else
          redirect_to success_payment_path(order.GUID)
        end

      rescue => e
        notify_airbrake(e)
        redirect_to error_payment_path("Error payment")
        return
      end
    when PaymentInfo::TYPE_PAYMENT.invert['buy paypal']
      if ::APP_CONFIG['skip_paypal']
        redirect_to success_payment_path(order.GUID)
      else
        redirect_to :controller => :pay_pal, :action => :checkout, :amount => amount, :g => order.GUID
      end
    when PaymentInfo::TYPE_PAYMENT.invert['withdraw paypal']
      redirect_to success_payment_path(order.GUID)
    when PaymentInfo::TYPE_PAYMENT.invert['check']
      redirect_to success_payment_path(order.GUID)
    else
      redirect_to cart_path
    end
  end

  private
  def process_payment(creditcard, amount, order)
    begin
      # for testing credit card
      if ::APP_CONFIG['skip_credit_card']
        @result = "Success: " + "Credit Card Authoization Skipped"
        return @result
      else
        gateway = (@gateway ||= ActiveMerchant::Billing::PaypalGateway.new(
          :login => ::APP_CONFIG['gateway_login'],
          :password => ::APP_CONFIG['gateway_password'],
          :signature => ::APP_CONFIG['gateway_signature']
        ))
      end

      if creditcard.valid?
        response = gateway.authorize(amount, creditcard, {:ip=>request.remote_ip, :billing_address=>{
          :first_name     => order.BillingFirstName,
          :last_name => order.BillingLastName,
          :address1 => order.BillingAddress,
          :city     => order.BillingCity,
          :state    => order.BillingState,
          :zip      => order.BillingZip,
          :phone    => order.BillingPhone,
          :e_mail => order.BillingEmail,
          :country => 'US'
        }})
        if response.success?
          ret = gateway.capture(amount, response.authorization)
          @result = "Success: " + response.message.to_s
        else
          @result = "Fail: " + response.message.to_s
        end
      else
        @result = "Credit card not valid: " + creditcard.validate.to_s
      end
    rescue Exception => e
      notify_airbrake(e)
      Rails.logger.error(e)
    end
  end

  def create_venmo
    @venmo = Venmo.new(session)
  end

  PAYPAL_END_POINT_URL_TEST = "https://api-3t.sandbox.paypal.com/nvp"
end
