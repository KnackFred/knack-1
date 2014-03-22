require "product_params"
class AdministrativeController < ApplicationController

  def save_template
    template = ParamTemplate.new(params[:template])
    product = Product.find(template.product_id)
    template.partner_id = product.get_partner_id

    unless template.valid_param?
      render :text => 0
      return
    end

    begin
      product_param = ProductParam.find(template.id)
    rescue
      product_param = nil
    end

    if product_param.blank?
      product_param = ProductParam.new(:Name => template.name,
              :IsTemplate => 1,
              :Product_ID => template.product_id,
              :Partner_ID => template.partner_id)
      if product_param.save
        template.list_values.each do |v|
          ValueParam.create(:Value => v, :ProductParam_ID => product_param.id)
        end
      else
        render :text => 0
        return
      end
    else
      if product_param.update_attributes(:Name => template.name,
              :IsTemplate => 1)

        product_param.delete_values
        template.list_values.each do |v|
          ValueParam.create(:Value => v, :ProductParam_ID => product_param.id)
        end
      else
        render :text => 0
        return
      end
    end

    render :text => product_param.id
    return
  end

  def delete_template
    if params[:id].blank?
      render :text => 0
      return
    else
      product_param = ProductParam.find(params[:id])
      product_param.update_attributes(:IsTemplate => 0)
      render :text => product_param.id
      return
    end
  end

  #######################################################
  # Action LOGOUT
  #######################################################
  def logout
    session[:knack] = nil
#    session[:site] = nil
    session[:cart] = nil

    if cookies[:remember_me_id] then
      cookies.delete :remember_me_id
    end
    if cookies[:remember_me_code] then
      cookies.delete :remember_me_code
    end
    if cookies[:remember_partner_id] then
      cookies.delete :remember_partner_id
    end
    if cookies[:remember_partner_code] then
      cookies.delete :remember_partner_code
    end
    redirect_to :controller => :registrant,:action => :home
  end

  #######################################################
  # ATION TO PARTNER
  #######################################################
  def topartner
    partner = Partner.find(params[:id])

    session[:registrant] = nil
    session[:partner] = nil
    session[:administrator] = nil
    session[:partner_administrator] = nil
    session[:knack] = nil

    session[:partner]= partner.id

    redirect_to :controller => :partner, :action => :partnerprofile
  end

  #######################################################
  # ATION TO REGISTRY
  #######################################################
  def toregistry
    registrant = Registrant.find(params[:id])

    session[:registrant] = nil
    session[:partner] = nil
    session[:administrator] = nil
    session[:partner_administrator] = nil
    session[:knack] = nil

    session[:registrant]= registrant.id
    session[:cart] = Cart.new()

    redirect_to :controller => :registrant, :action => :profile
  end

  #######################################################
  # ACTION PROFILE
  #######################################################
  def profile

    @err_oldpassword = ''
    @err_newpassword = ''
    @admin = administrator

    if request.post?

      if !params[:newpassword].blank? || !params[:oldpassword].blank?
        @passCheck = 'checked="checked"'
        unless PasswordUtilities.check(params[:oldpassword], @admin.Password)
          @err_oldpassword = StaticDataUtilities.get_prepare_error_message + 'Error old password'
        else
          if params[:newpassword].length < 5
            @err_newpassword = StaticDataUtilities.get_prepare_error_message + 'Password length must be greater than 5'
          end
        end
      end

      if @err_oldpassword != '' || @err_newpassword != ''
        return
      end

       if @admin.update_attribute(:Password, params[:newpassword].blank? ? @admin.Password : PasswordUtilities.hash(params[:newpassword]))
          @passCheck = ''
          @is_saved = true
       end
    end
  end

  #######################################################
  # ACTION STATS
  #######################################################
  def statistics

    @statistics = Statistics.get_statistics(DateTime.now, false)

    @admin = administrator

    @show_year = false
  end

  #######################################################
  # ACTION STATS
  #######################################################
  def full_statistics

    @statistics = Statistics.get_statistics(DateTime.now, true)

    @admin = administrator

    @show_year = true
    render :statistics

  end

  #######################################################
  # ATION PARTNERS
  #######################################################
  def partners

    @filter = FilterPartners.new()
    #################################
    #Filter
    #################################
    @statuses = StaticDataUtilities.get_status_accounts

    if request.post?
      @filter.id = params[:filter][:id]
      @filter.partner = params[:filter][:partner]
      @filter.date_from = params[:filter][:date_from]
      @filter.date_to = params[:filter][:date_to]
      @filter.status_id = params[:filter][:status_id].to_i
      @show_report = params[:show_report]
    end

    @partners = @filter.filter()

    #################################
    #Pager
    #################################
    if params[:countP].blank?
      count_page = 50
    else
      count_page = params[:countP]
    end

    @pager = Pager.new(count_page, @partners.length, params[:currentP])

    #################################
    #Sort
    #################################

    @partners = Pager.get_array(@pager.page_size, @partners, 1, @pager.offset)
  end

  #######################################################
  # ATION REGISTRANTS
  #######################################################
  def registrants

    @filter = FilterRegistrants.new()
    #################################
    #Filter
    #################################
    @statuses = StaticDataUtilities.get_status_accounts

    if request.post?
      @filter.id = params[:filter][:id]
      @filter.registrant = params[:filter][:registrant]
      @filter.date_from = params[:filter][:date_from]
      @filter.date_to = params[:filter][:date_to]
      @filter.status_id = params[:filter][:status_id].to_i
      @filter.details = params[:filter][:details] == "1"
    end

    @registrants = @filter.filter()

    #################################
    #Pager
    #################################
    if params[:countP].blank?
      count_page = 20
    else
      count_page = params[:countP]
    end

    @pager = Pager.new(count_page, @registrants.length, params[:currentP])

    #################################
    #Sort
    #################################

    @registrants = Pager.get_array(@pager.page_size, @registrants, 1, @pager.offset)
  end



  def categorylist
    #################################
    #Filter
    #################################
    @name = params[:fname].blank? ? '' : params[:fname]

    name = '%'+@name+'%'
    @categories = Category.where("name LIKE ?", name).order("priority DESC, id").paginate(:page => params[:page], :per_page => 50)

  end

  def editcategory
    @admin = administrator
    if request.post?
      expire_categories_cache

      if params[:id].blank?
        @category = Category.new(params[:category])

        if @category.save
          redirect_to :controller => :administrative, :action => :categorylist
          return
        end
      else
        @category = Category.find(params[:id])
        if @category.update_attributes(params[:category])
          redirect_to :controller => :administrative, :action => :categorylist
          return
        end
      end

    else
      params[:id].blank? ? @category = Category.new() : @category = Category.find(params[:id])
      @category.parent_name = @category.parent.name unless @category.parent.blank?
    end

    #@categories = Category.find(:all);

  end

  ##############################################
  # ACTION ORDERS
  ##############################################
  def orders
    #--------------------------
    #  Get records
    #--------------------------
    @admin = administrator

    @stores = StaticDataUtilities.get_stores_select()
    @statuses = StaticDataUtilities.get_order_status_select

    #################################
    #Filter
    #################################
    @sort_params = StaticDataUtilities.get_sort_params
    @sort = SortOrders.new()
    @filter = FilterOrders.new()

    if request.post?
      @filter.customer = params[:filter][:customer]
      @filter.order_id = params[:filter][:order_id]
      @filter.store_id = params[:filter][:store_id].to_i
      @filter.status_id = params[:filter][:status_id].to_i
      @filter.datepicker_from = params[:filter][:datepicker_from]
      @filter.datepicker_to = params[:filter][:datepicker_to]
      @filter.gross_from = params[:filter][:gross_from]
      @filter.gross_to = params[:filter][:gross_to]
      @filter.paid_full = params[:filter][:paid_full]
      @filter.type_order = params[:filter][:type_order].to_i
    end

    @orders = Order.order(:id.desc).all#.find(:all)


#    @orders = (@orders.sort_by { |e| e.id.to_i  }).reverse

    #################################
    #Search
    #################################

    @orders = @filter.filter(@orders)

    #################################
    #Pager
    #################################
    if params[:countP].blank?
      page_size = 50
    else
      page_size = params[:countP]
    end
    @pager = Pager.new(page_size, @orders.length, params[:currentP])

    @total = @orders.sum { |p| p.Amount.to_f }

    #################################
    #Sort
    #################################

    @orders = @sort.sort(@orders, @pager.offset, @pager.page_size)

  end

   ##############################################
  # ACTION ORDERS
  ##############################################
  def canceled_payments
    #--------------------------
    #  Get records
    #--------------------------
    #@partner = Partner.find(session[:knack])
    @admin = administrator

    @statuses = StaticDataUtilities.get_closed_payment_status_select
    @type_payments = StaticDataUtilities.get_types_payments

    #################################
    #Filter
    #################################
    @sort_params = StaticDataUtilities.get_sort_params
    @sort = SortOrders.new()
    @filter = FilterCanceledPayments.new()

    if request.post?
      @filter.customer = params[:filter][:customer]
      @filter.order_id = params[:filter][:order_id]
      @filter.status_id = params[:filter][:status_id].to_i
      @filter.datepicker_from = params[:filter][:datepicker_from]
      @filter.datepicker_to = params[:filter][:datepicker_to]
      @filter.type_payment = params[:filter][:type_payment].to_i
    end

    @canceled_payments = ClosedPayment.find(:all, :include => [:order])


    @canceled_payments = (@canceled_payments.sort_by { |e| e.id.to_i  }).reverse

    #################################
    #Search
    #################################

    @canceled_payments = @filter.filter(@canceled_payments)

    #################################
    #Pager
    #################################
    if params[:countP].blank?
      page_size = 50
    else
      page_size = params[:countP]
    end
    @pager = Pager.new(page_size, @canceled_payments.length, params[:currentP])

    #################################
    #Sort
    #################################

    @canceled_payments = @sort.sort(@canceled_payments, @pager.offset, @pager.page_size)

  end

  require "mail_utilities"
  ##############################################
  # ACTION ORDER
  ##############################################
  def order
    if !params[:id].blank?
      @admin = administrator
      @order = Order.find(params[:id])

      if request.post?
        Order.connection.transaction do
          unless params[:canceled_o2p].blank?

            params[:canceled_o2p].each do |o2p|
              if o2p[1].to_i == 2
                order2product = Orders2product.find(:first, :conditions => ["id = ? AND status_id = 1", o2p[0]])

                order2product.cancel_line unless order2product.blank?
              end
            end
          end

          unless params[:canceled_o2r2p].blank?

            params[:canceled_o2r2p].each do |o2p|
              if o2p[1].to_i == 2
                order2registrant2product = Orders2registryItem.find(:first, :conditions => ["id = ? AND status_id = 1", o2p[0]])

                order2registrant2product.cancel_line unless order2registrant2product.blank?
              end
            end
          end

          current_status = @order.OrdersStatus_ID.to_i
          new_status = params[:order][:OrdersStatus_ID].blank? ? OrdersStatus::STATUSES.invert['Canceled'] : params[:order][:OrdersStatus_ID].to_i

          if @order.update_attributes(:OrdersStatus_ID => new_status,
            :ShippingMethod_ID => params[:order][:ShippingMethod_ID],
            :ShipmentTracking => params[:order][:ShipmentTracking],
            :DeliveryDate => params[:order][:DeliveryDate])

            if current_status != 3 && new_status == 3
              money_back = 0.0

              if @order.registrant_id.blank?
                type_payment = @order.typepayment.blank? ? Typepayment::CREDIT_CARD : @order.typepayment.id
              else
                type_payment = Typepayment::KNACK_CREDIT
              end

              amount = @order.Amount.to_f - money_back

              if amount > 0
                closed_payment = ClosedPayment.new(:order_id => @order.id,
                                                 :typepayment_id => type_payment,
                                                 :status_id => 1,
                                                 :amount => amount)
                begin
                closed_payment.save
                rescue
                end
              end

              MailUtilities.send_cancel_payment(@order)
            end

            redirect_to :controller => :administrative, :action => :orders
            return
          end
        end
      end


      @order_statuses = StaticDataUtilities.get_list_order_status

      unless @order.order_type == Order::BUY
         @order_statuses.delete_if {|o| o.id == OrdersStatus::STATUSES.invert['Canceled']}
      end

      @shipping_methods = StaticDataUtilities.get_shipping_method_select
      @line_statuses = LineStatus.find(:all)

      @shipment_cost = 0

    else
      redirect_to :controller => :administrative, :action => :orders
      return
    end
  end

  ##############################################
  # ACTION ORDER
  ##############################################
  def canceled_payment
    if !params[:id].blank?
      @admin = administrator
      @payment = ClosedPayment.find(params[:id], :include => [:order])

      if request.post?
        current_status = @payment.status_id.to_i
        new_status = params[:payment][:status_id].blank? ? 3 : params[:payment][:status_id].to_i

        @payment.update_attribute :status_id, new_status

        if current_status != 2 && new_status == 2

          if @payment.typepayment_id.to_i == Typepayment::KNACK_CREDIT
            registrant = Registrant.find(@payment.order.registrant_id)

            registrant.update_attribute :Cash, registrant.Cash.to_f + @payment.amount
          end

          MailUtilities.send_money_back(@payment)
        end

        redirect_to :controller => :administrative, :action => :canceled_payments
        return
      end

      @payment_statuses = ClosedPaymentStatus.find(:all)

    else
      redirect_to :controller => :administrative, :action => :canceled_payments
      return
    end
  end

  ##############################################
  # ACTION CREDITS
  ##############################################
  def credits
    @admin = administrator

    if !params[:o2pid].blank? || !params[:o2r2pid].blank? || !params[:wid].blank?
      #---------------------------
      #- Products
      #---------------------------
      if !params[:o2pid].blank?
        @o2p = Orders2product.find(params[:o2pid])
        @payments = KnackPayment.find(:all, :conditions => ["Order2Product_ID = ?", params[:o2pid]])
      else
        if !params[:o2r2pid].blank?
          @o2r2p = Orders2registryItem.find(params[:o2r2pid])
          @payments = KnackPayment.find(:all, :conditions => ["order2registry_item_id = ?", params[:o2r2pid]])
        else
          unless params[:wid].blank?
            @withdrawal = Withdrawal.find(params[:wid])
            @payments = KnackPayment.find(:all, :conditions => ["Withdrawal_ID = ?", params[:wid]])
          end
        end
      end

      #---------------------------
      #- Payments
      #---------------------------
      @payments = (@payments.sort_by { |e| e.id.to_i }).reverse
    else
      redirect_to :controller => :administrative, :action => :order, :id => params[:oid]
      return
    end
  end

  ##############################################
  # ACTION STATE LIST
  ##############################################
  def statelist
    #################################
    #Filter
    #################################
    @states = StaticDataUtilities.get_states


    #################################
    #Pager
    #################################
    params[:countP].blank? ? @page_size = 8 : @page_size = Integer(params[:countP])
    count_record = @states.length

    @count_page = (count_record.to_f / @page_size.to_f).ceil

    params[:currentP].blank? ? @current_page = 1 : @current_page = Integer(params[:currentP])
    @current_page <= 0 ? @current_page = 1 : a = 1
    @current_page > @count_page ? @current_page = @count_page : a = 1

    offset = @page_size * (@current_page - 1)

    @pager = Array.new
    @leftpager = Array.new
    @rightpager = Array.new
    #prev page
    @prev_page = @current_page == 1 ? 1 : @current_page - 1
    #next page
    @next_page = @current_page == @count_page ? @count_page : @current_page + 1

    #pages

    #leftpart pager
    if @count_page <= 6
      1.upto(@count_page) do |i|
        @leftpager << i
      end
    else

      if @current_page >= @count_page - 5
        @leftpager = Array.new
        (@count_page - 5).upto(@count_page-3) do |i|
          @leftpager << i
        end
      else
        @current_page.upto(@current_page + 2) do |i|
        @leftpager << i
        end
      end

      @rightpager << @count_page - 2
      @rightpager << @count_page - 1
      @rightpager << @count_page
    end
    @states = apply_pager(@states, offset, @page_size)
  end

  ##############################################
  # ACTION EDIT STATE
  ##############################################
  def editstate
    params[:id].blank? ? @state = State.new() : @state = State.find(params[:id])

    if request.post?
      if (params[:iscancel] == 'true')
        redirect_to :controller => :administrative, :action => :statelist
        return
      end

      if params[:id].blank?
        #---------------------
        #- Add state
        #---------------------
        @state = State.new(:Name => params[:state][:Name], :GeneralTax => params[:state][:GeneralTax])

        if @state.save
          redirect_to :controller => :administrative, :action => :statelist
          return
        else
          return
        end
      else
        #---------------------
        #- Update state
        #---------------------
        if @state.update_attributes(:Name => params[:state][:Name], :GeneralTax => params[:state][:GeneralTax])

          redirect_to :controller => :administrative, :action => :statelist
          return
        end
      end
    end
  end


  ##############################################
  # ACTION ADD PAYMENT
  ##############################################
  def addpayment
    @admin = administrator

    if !params[:o2pid].blank? || !params[:o2r2pid].blank? || !params[:wid].blank?
      #---------------------------
      #- Products
      #---------------------------
      if !params[:o2pid].blank?
        @o2p = Orders2product.find(params[:o2pid])
        store = @o2p.product.get_default_store
        if !store.blank?
          partner_id = store.PartnerID
        end
      else
        if !params[:o2r2pid].blank?
          @o2r2p = Orders2registryItem.find(params[:o2r2pid])
          store = @o2r2p.registry_item.product.get_default_store
          if !store.blank?
            partner_id = store.PartnerID
          end
        else
          if !params[:wid].blank?
            @withdrawal = Withdrawal.find(params[:wid])
            partner_id = nil
            registrant = Registrant.find(@withdrawal.Registrant_ID)
          end
        end
      end

      if request.post?
        @knack_payment = KnackPayment.new(:Amount => params[:amount_knack],
        :Order2Product_ID => params[:o2pid],
        :order2registry_item_id => params[:o2r2pid],
        :Withdrawal_ID => params[:wid],
        :Partner_ID => partner_id,
        :DateTime => DateTime.now
        )

        if @knack_payment.save
          unless params[:wid].blank?
            MailUtilities.send_registrant_payment_notice(registrant.Email, params[:oid])
          else
            unless partner_id.blank?
              partner = Partner.find(partner_id)
              MailUtilities.send_partner_payment_notice(partner.Email, params[:oid])
            end
          end
          redirect_to :controller => :administrative, :action => :order, :id => params[:oid]
          return
        else
          render
          return
        end
      else
        return
      end

    else
      redirect_to :controller => :administrative, :action => :order, :id => params[:oid]
      return
    end
  end

  #######################################################
  # Action GET TREE CATEGORIES
  #######################################################
  def gettreecategories
    render :text => Category.get_csv
  end

  #######################################################
  # Action GET TREE STORES
  #######################################################
  def getstores
    render :text => Store.get_csv
  end

  #######################################################
  # Action GET NAME CATEGORY
  #######################################################
  def getnamecategory
    category = Category.find(params[:id])
    unless category.blank?
      render :text => category.name
      return
    else
      render :text => ''
      return
    end
  end
  #######################################################
  # Action GET Tempale
  #######################################################
  def gettemplate
    template = ProductParam.find_by_id(params[:id])
    unless template.blank?
      template.values = template.value_params
      render :json => template
      return
    else
      render :json => nil
      return
    end
  end

  #######################################################
  # Action GET Tempale
  #######################################################
  def gettemplatelist
    render :json => StaticDataUtilities.get_product_params_select()
  end

  #######################################################
  # Action GET Tempale
  #######################################################
  def getvalues
    template = ProductParam.find_by_id(params[:id])
    unless template.blank?
      values = template.value_params
      render :json => values
    else
      render :json => nil
    end
  end


  #######################################################
  # Action GET NAME COLOR
  #######################################################
  def getnamecolor
    color = Color.find(params[:id])
    unless color.blank?
      render :text => color.Name
      return
    else
      render :text => ''
      return
    end
  end

  #######################################################
  # Action GET NAME STORE
  #######################################################
  def getnamestore
    store = Store.find(params[:id])
    unless store.blank?
      name = store.IsDefault ? store.Name + ' <i>(default)</i>' : store.Name
      render :text => name
      return
    else
      render :text => ''
      return
    end
  end

  #######################################################
  # Action colors
  #######################################################
  def colors
    @colors = Color.find(:all).reverse

    #################################
    #Pager
    #################################
    if params[:countP].blank?
      count_page = 50
    else
      count_page = params[:countP]
    end

    @pager = Pager.new(count_page, @colors.length, params[:currentP])

    #################################
    #Sort
    #################################

    @colors = Pager.get_array(@pager.page_size, @colors, 1, @pager.offset)
  end

  #######################################################
  # Action color
  #######################################################
  def color
    @admin = administrator
    if request.post?
      if params[:id].blank?
        @color = Color.new(:Name => params[:color][:Name], :RGB => params[:color][:RGB])
        begin
          if @color.save
            redirect_to :controller => :administrative, :action => :colors
            return
          end
        rescue
        end
      else
        @color = Color.find(params[:id])
        if @color.update_attributes(:Name => params[:color][:Name], :RGB => params[:color][:RGB])
          redirect_to :controller => :administrative, :action => :colors
          return
        end
      end
    else
      if params[:id].blank?
        @color = Color.new
      else
        @color = Color.find(params[:id])
      end
    end

  end

  #######################################################
  # ATION STORES
  #######################################################
  def stores

    @filter = FilterStores.new()
    #################################
    #Filter
    #################################
    if request.post?
      @filter.id = params[:filter][:id]
      @filter.name = params[:filter][:name]
      @filter.partner = params[:filter][:partner]
      @filter.city = params[:filter][:city]
    end


    @stores = @filter.filter()


    #################################
    #Pager
    #################################
    if params[:countP].blank?
      count_page = 50
    else
      count_page = params[:countP]
    end

    @pager = Pager.new(count_page, @stores.length, params[:currentP])

    #################################
    #Sort
    #################################
    @stores = Pager.get_array(@pager.page_size, @stores, 1, @pager.offset)
  end

  def toggle_partner_deleted
    expire_stores_cache
    if request.post?
      unless params[:id].blank?
        partner = Partner.find(params[:id])
        partner.update_attribute(:IsDeleted, !partner.IsDeleted)
        text = partner.IsDeleted.blank? ? 'Active' : 'Deleted'
        render :text => text
        return
      end
    end
  end

  def toggle_partner_activated
    expire_stores_cache
    if request.post?
      unless params[:id].blank?
        partner = Partner.find(params[:id])
        partner.update_attribute(:IsActivated, !partner.IsActivated)
        text = partner.IsActivated.blank? ? 'Not Activated' : 'Activated'
        render :text => text
        return
      end
    end
  end

  def activeregistries
    if request.post?
      unless params[:id].blank?
        registrant = Registrant.find(params[:id])
        registrant.update_attribute(:IsDeleted, !registrant.IsDeleted)
        text = registrant.IsDeleted.blank? ? 'Active' : 'Closed'
        render :text => text
        return
      end
    end
  end

  def toggle_store_visible
    unless params[:id].blank?
      expire_stores_cache
      store = Store.find(params[:id])
      store.toggle!(:visible)
      redirect_to :back
    end
  end

  private
  def apply_pager(array, offset, page_size)
    if array.length > 0
      array = Pager.array_mod(array, 1, offset)
      array = array.first(page_size)
      return array
    end
  end

end
