require 'cart'
require 'math_utilite'
class BuyController < ApplicationController
  #######################################################
  # Action CONTRIBUTE
  #######################################################
  def contribute
    unless Cart.valid_cart_for_contribute?(session)
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::MIXED_CART
      return
    end

    @registry_item = RegistryItem.find(params[:id])
    raise ActiveRecord::RecordNotFound if @registry_item.IsDeleted?

    if request.post?
      @buy_registry_item = BuyRegistryItem.new(
          :type => BuyRegistryItem::CONTRIBUTE,
          :from => params[:buy_registry_item][:from],
          :notes => params[:buy_registry_item][:notes],
          :quantity => params[:buy_registry_item][:quantity],
          :contribute => params[:buy_registry_item][:contribute],
          :item => @registry_item
      )

      if @buy_registry_item.valid?
        if Cart.add_registry_item_to_cart(session, @buy_registry_item, 'contribute')
          @status = 1
          @param = 0
          render 'shared/close_modal', :layout => false
        else
          redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::ALREADY_IN_CART
        end
      end
    else
      @buy_registry_item = BuyRegistryItem.new(:item => @registry_item, :type => BuyRegistryItem::CONTRIBUTE)
    end
  end

  #######################################################
  # Action BUY HIMSELF
  #######################################################
  def buy_himself
    unless Cart.valid_cart_for_buy?(session)
      render :text => ErrorMessages::MIXED_CART
      return
    end

    product = Product.find(params[:id])
    raise ActiveRecord::RecordNotFound if product.IsDeleted?

    @buy_product = BuyProduct.new(
        :product => product,
        :quantity => params[:quantity],
        :color_id => params[:color_id],
        :params => params[:product_params]
    )


    if @buy_product.valid?
      if Cart.add_product_to_cart(session, @buy_product)
        render :nothing => true
      else
        render :text => ErrorMessages::CUSTOM
        return
      end
    else
      render :text => ErrorMessages::VALIDATION
    end
  end

  #######################################################
  # Action Order an item from the cart that has already been purchased by a guest.
  #######################################################
  def   buy_order
    unless Cart.valid_cart_for_buy?(session)
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::MIXED_CART
      return
    end

    registry_item = RegistryItem.find(params[:id])
    raise ActiveRecord::RecordNotFound if registry_item.IsDeleted?
    raise ActiveRecord::RecordNotFound if registry_item.registrant != registrant

    buy_reg_item = BuyRegistryItem.new(
        :type => BuyRegistryItem::ORDER,
        :item => registry_item
    )

    raise "invalid buy_registry_item" unless buy_reg_item.valid?

    if Cart.add_registry_item_to_cart(session, buy_reg_item, 'buy himself')
      @status = 2
      @param = registry_item.id
      render 'shared/close_modal', :layout => false
    else
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::ALREADY_IN_CART
    end

  end

  #######################################################
  # Action Order an item from another site.
  #######################################################
  def   buy_ext
    @registry_item = RegistryItem.find(params[:id])
    if request.post?
      @buy_registry_item = BuyRegistryItem.new(
          :item => @registry_item,
          :quantity => params[:buy_registry_item][:quantity],
          :from => params[:buy_registry_item][:from],
          :notes => params[:buy_registry_item][:notes],
          :email => params[:buy_registry_item][:email],
          :type => BuyRegistryItem::EXTERNAL)

      if @buy_registry_item.valid?()
        order = Order.new(
            :OrdersStatus_ID => OrdersStatus::STATUSES.invert['New'],
            :DateTime => DateTime.now,
            :order_type => Order::EXTERNAL,
            :Amount => 0,
            :registrant_id => session[:registrant],
            :BillingEmail => params[:buy_registry_item][:email]
        )
        if order.save && order.buy_item_external(@buy_registry_item)
          render "buy_ext_success"
          return
        end
      end

    else
      @buy_registry_item = BuyRegistryItem.new(:item => @registry_item, :type => BuyRegistryItem::EXTERNAL)
    end
  end

  #######################################################
  # Edit an external contribution
  #######################################################
  def edit_ext_order
    @order = Order.find(params[:id])
    raise Exceptions::AccessDenied unless @order.order_type == Order::EXTERNAL

    @contribution = @order.contributes.limit(1)[0]
    @registry_item = @contribution.registry_item

    if request.get?
      @buy_registry_item = BuyRegistryItem.new(:item => @registry_item,
                                             :contribute => @contribution.Contribute,
                                             :from => @contribution.From,
                                             :notes => @contribution.Notes,
                                             :email => @order.BillingEmail,
                                             :type => BuyRegistryItem::EXTERNAL)
      # Remove the old contribution amount from the max_contribution
      @buy_registry_item.max_contribution += @contribution.Contribute
      @buy_registry_item.max_quantity += @registry_item.quantity_for_contribution(@contribution.Contribute)
    else
      @buy_registry_item = BuyRegistryItem.new(:item => @registry_item,
                                               :quantity => params[:buy_registry_item][:quantity],
                                               :from => params[:buy_registry_item][:from],
                                               :notes => params[:buy_registry_item][:notes],
                                               :email => @order.BillingEmail,
                                               :type => BuyRegistryItem::EXTERNAL)
      # Remove the old contribution amount from the max_contribution
      @buy_registry_item.max_contribution += @contribution.Contribute
      @buy_registry_item.max_quantity += @registry_item.quantity_for_contribution(@contribution.Contribute)
      if @buy_registry_item.valid? && @contribution.update_attributes(
          :Contribute => @buy_registry_item.total,
          :From => @buy_registry_item.from,
          :Notes => @buy_registry_item.notes)
        flash.notice = "Contribution Updated"
        @registry_item.reload
      end
    end
  end

  #######################################################
  # Edit an external contribution
  #######################################################
  def destroy_ext_order
    order = Order.find(params[:id])
    raise Exceptions::AccessDenied unless order.order_type == Order::EXTERNAL
    @registry = order.registry_items.first.registrant
    if order.destroy
      flash.now.notice = "Order Deleted"
    else
      flash.now.alert = "Unable to delete the order"
    end
  end

  #######################################################
  # Action exchange
  #######################################################
  def exchange
    unless Cart.valid_cart_for_withdraw?(session)
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::MIXED_CART
      return
    end

    registry_item = RegistryItem.find(params[:id])
    raise ActiveRecord::RecordNotFound if registry_item.IsDeleted?
    raise ActiveRecord::RecordNotFound if registry_item.registrant != registrant

    if Cart.add_item_for_withdrawal(session, registry_item)
      @status = 3
      @param = registry_item.id
      render 'shared/close_modal', :layout => false
    else
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::ALREADY_IN_CART
    end
  end

  #######################################################
  # Action CONTRIBUTORS
  #######################################################
  def contributors
    @item = RegistryItem.find(params[:id])
  end

  #######################################################
  # When a user buys an item off their registry that has not yet been purchased by a guest.
  #######################################################
  def buy_available
    unless Cart.valid_cart_for_buy?(session)
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::MIXED_CART
      return
    end

    @registry_item = RegistryItem.find(params[:id])
    raise ActiveRecord::RecordNotFound if @registry_item.IsDeleted?
    raise ActiveRecord::RecordNotFound if @registry_item.registrant != registrant

    if request.post?
      unless @registry_item.update_attributes :Quantity => params[:registry_item][:Quantity]
         return
      end

      @buy_registry_item = BuyRegistryItem.new(
          :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY,
          :item => @registry_item
      )

      raise "invalid buy_registry_item" unless @buy_registry_item.valid?

      if Cart.add_registry_item_to_cart(session, @buy_registry_item, 'buy himself')
        @status = 1
        @param = @registry_item.id
        render 'shared/close_modal', :layout => false
      else
        redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::ALREADY_IN_CART
      end

    else
      @registry_item = RegistryItem.where(:id => params[:id], :IsDeleted => false).first
    end
  end

  #######################################################
  # Action ERROR PAGE
  #######################################################
  def errorpage
    unless params[:id].blank?
      @message = ErrorMessages.get_text_error(params[:id], params[:message])
    end
  end

  private

  def registry_item_exists?(id)
    return false if id.blank?

    return RegistryItem.where(:id => id, :IsDeleted => false).exists?
  end

  def item_exists?(id)
    return false if id.blank?

    return Product.where(:id => id, :IsDeleted => false).exists?
  end
end
