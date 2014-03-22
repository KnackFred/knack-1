require "product_params"
class PartnerController < ApplicationController

  def upload_image
    @partner = partner
    unless request.get?
      @call = "upload_image"
      if @partner.update_attributes(params[:partner])
        @status = "true"
        @param = "/partner/crop_image"
      else
        @status = "false"
        @param = "There has been a validation error.  Please check that your profile is filled out, and that the image you selected is a JPG, JPEG or PNG under 3 MB."
      end
      render 'shared/close_modal', :layout => "empty"
      return
    end
    render 'shared/upload_image', :layout => "empty", :locals => {:model => @partner,  :attachment => :logo}
  end

  def crop_image
    @partner = partner
    @call = "crop_image"
    unless request.get?
      if @partner.update_attributes(params[:partner])
        @status = "true"
        @param = @partner.logo.url(:medium)
      else
        @status = "false"
        @param = @partner.errors.to_s
      end
      render 'shared/close_modal', :layout => "empty"
      return
    end
    render 'shared/crop_image', :layout => "empty", :locals => {:model => @partner,  :attachment => :logo, :action => "crop_image"}
  end

  #######################################################
  # ATION SAVE TEMPLATE
  #######################################################
  def save_template
    template = ParamTemplate.new(params[:template])
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

  #######################################################
  # ATION DELETE TEMPLATE
  #######################################################
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
  # Action GET Tempale List
  #######################################################
  def gettemplatelist
    render :json => StaticDataUtilities.get_partner_product_params_select(session[:partner])
  end

  ##############################################
  # ACTION FOR PARTNERSLOGIN
  ##############################################
  def partnerslogin
    session[:registrant] = nil
    session[:partner] = nil
    session[:administrator] = nil
    session[:partner_administrator] = nil
    session[:knack] = nil

    begin
      if ( cookies[:remember_partner_id] and
          Partner.find(:first, :conditions => ["id = ? AND IsDeleted = 0", cookies[:remember_partner_id]]) and
            Digest::SHA1.hexdigest( Partner.find(:first, :conditions => ["id = ? AND IsDeleted = 0", cookies[:remember_partner_id]]).Email )[4,18] == cookies[:remember_partner_code]  )
        @u = Partner.find(:first, :conditions => ["id = ? AND IsDeleted = 0", cookies[:remember_partner_id]])

        begin
          @u.update_attribute(:Logins, @u.Logins.to_i + 1)
        rescue
        end

        session[:cart] = Cart.new()

        if (@u.Email == 'fred@knackregistry.com' || @u.Email == 'john@knackregistry.com')
          session[:knack] = @u.id
          redirect_to :controller => :administrative, :action => :profile
          return
        else
          session[:partner]= @u.id
          redirect_to :controller => :partner, :action => :partnerprofile
          return
        end
      end
    rescue
    end

    if request.post?
      @err_email = ''
      @err_pass = ''
      @err_captcha = ''

      if params[:partner][:Email].blank?
        @err_email = StaticDataUtilities.get_prepare_error_message + "can't be blank"
      end

      if params[:partner][:Password].blank?
        @err_pass = StaticDataUtilities.get_prepare_error_message + "can't be blank"
      end

      if(@err_email != '' || @err_pass != '' || @err_captcha != '')
        return
      end

      begin
        partner =Partner.check(params['partner'][:Email], params['partner'][:Password])

        unless partner.blank?
          if params[:rememberMe]
            userId = (partner.id).to_s
            cookies[:remember_partner_id] = { :value => userId, :expires => 30.days.from_now }
            userCode = Digest::SHA1.hexdigest( partner.Email )[4,18]
            cookies[:remember_partner_code] = { :value => userCode, :expires => 30.days.from_now }
          end

          begin
            partner.update_attribute(:Logins, partner.Logins.to_i + 1)
          rescue
          end

          session[:cart] = Cart.new()
          if (params[:partner][:Email] == 'fred@knackregistry.com' || params[:partner][:Email] == 'john@knackregistry.com')
            session[:knack] = partner.id
            redirect_to :controller => :administrative, :action => :profile
            return
          else
            session[:partner]= partner.id
            redirect_to :controller => :partner, :action => :partnerprofile
            return
          end
        else
          administrator = PartnerAdministrator.check_administrator(params[:partner][:Email], params[:partner][:Password])
          unless administrator.blank?
            session[:partner]= administrator.partner_id
            session[:partner_administrator] = administrator.id
            session[:cart] = Cart.new()
            redirect_to admin_partner_administrator_path(administrator.id)
            return
          else
            @err_email = StaticDataUtilities.get_prepare_error_message + "There is no such login or password"
          end

        end
        @err_email = StaticDataUtilities.get_prepare_error_message + "There is no such login or password"
        #        flash[:notice] = "Username or password invalid"
        end

    end
  end

  #######################################################
  # ACTION FORGOT PASSWORD
  #######################################################

  def forgotpassword
    if request.post?
      @erremail = ''
      if params[:partner][:email].blank?
        @erremail = StaticDataUtilities.get_prepare_error_message + "can't be blank"
        return
      end


      email = params[:partner][:email]

      @partner = Partner.find(:first, :conditions => ["Email = ? AND IsDeleted = 0", email])

      if !@partner.blank?
        MailUtilities.send_reset_partner_password(@partner)
        @sended = 2
      end
    else
      unless params[:id].blank?
        @partner = Partner.find(:first, :conditions => ["ImageGUID = ? AND IsDeleted = 0", params[:id]])
        if !@partner.blank?
          new_password = PasswordUtilities.generate_new
          password = PasswordUtilities.hash(new_password)
          @partner.update_attribute(:Password, password)
          MailUtilities.send_forgot_partner_password(@partner, new_password)
          @sended = 1
        end
      end
    end
  end

  #######################################################
  # Action LOGOUT
  #######################################################
  def partnerslogout
    session[:partner] = nil
#    session[:site] = nil
    session[:cart] = nil

    if cookies[:remember_partner_id] then
      cookies.delete :remember_partner_id
    end
    if cookies[:remember_partner_code] then
      cookies.delete :remember_partner_code
    end
    redirect_to :controller => :registrant, :action => :home
  end

  def activation
    @partner = Partner.find(:first, :conditions => ["ImageGUID = ? AND IsDeleted = 0", params[:id]])
    unless @partner.blank?
      unless @partner.IsActivated
        @partner.update_attribute(:IsActivated, 1)
        MailUtilities.send_activated(@partner.Email, @partner.Email)
      end
    end
  end

  #######################################################
  # Action PARTNERREGISTER
  #######################################################
  def partnerregister
    @states = StaticDataUtilities.get_states

    if request.post?
      @partner = Partner.new(:Email =>params[:partner][:Email],
        :Password=>params[:partner][:Password],
        :BillingName => params[:partner][:BillingName],
        :BillingLastName => params[:partner][:BillingLastName],
        :Password_confirmation => params[:partner][:Password_confirmation],
        :AgreeWithSitePolicy => params[:partner][:AgreeWithSitePolicy])

      if @partner.save
          password = PasswordUtilities.hash(@partner.Password)
          @partner.update_attribute(:Password, password)
          MailUtilities.send_activation_partner(@partner.Email, @partner.ImageGUID)
          redirect_to :controller => :partner, :action => :partnerconfirm, :email => params['partner'][:Email]
      end
    end
  end

  #######################################################
  # Action PROFILE
  #######################################################
  def partnerprofile
    @err_oldpassword = ''
    @err_newpassword = ''
    @partner = partner

    unless @partner.id.blank?
      @store = Store.where(:PartnerID => @partner.id, :IsDefault => true).first
      if @store.blank?
        @store = Store.new
      end
    end

    @newpassword = params[:newpassword]
    @oldpassword = params[:oldpassword]

    @states = StaticDataUtilities.get_states


    if !@newpassword.blank? || !@oldpassword.blank?
       @passCheck = 'checked="checked"'
       unless PasswordUtilities.check(params[:oldpassword], @partner.Password)
          @err_oldpassword = StaticDataUtilities.get_prepare_error_message + 'Error old password'
        else
          if @newpassword.length < 5
            @err_newpassword = StaticDataUtilities.get_prepare_error_message + 'Password length must be greater than 5'
          end
        end
     end

    if request.post?

     unless params[:set_use].blank?
       @store.Name = params[:store][:Name]
       @store.City = params[:store][:City]
       @store.State_ID = params[:store][:State_ID]
       @store.Street = params[:store][:Street]
       @store.ZIP = params[:store][:ZIP]
       @store.Phone = params[:store][:Phone]
       @store.Email = params[:store][:Email]

       @partner.Password = @newpassword.blank? ? @partner.Password : @newpassword
       @partner.Address = params[:partner][:Address]
       @partner.City = params[:partner][:City]
       @partner.State_ID = params[:partner][:State_ID]
       @partner.ZIP = params[:partner][:ZIP]
       @partner.PhoneNumber = params[:partner][:PhoneNumber]
       @partner.Email = params[:partner][:Email]
       @partner.WebSite = params[:partner][:WebSite]
       @partner.Description = params[:partner][:Description]
       @partner.BillingName = params[:partner][:BillingName]
       @partner.BillingLastName = params[:partner][:BillingLastName]
       @partner.BillingStreet = @store.Street
       @partner.BillingCity = @store.City
       @partner.BillingState_ID = @store.State_ID
       @partner.BillingZIP = @store.ZIP
       @partner.BillingPhone = @store.Phone
       @partner.BillingEmail = @store.Email
       @partner.PaymentSystem = params[:partner][:PaymentSystem]
       @partner.PayPalAccount = params[:partner][:PayPalAccount]
       @partner.Check = params[:partner][:Check]
       @partner.PartnerName = params[:partner][:PartnerName]

       render
       return
     end


     if @store.id.blank?
       @store = Store.create(:Name => params[:store][:Name],
       :City => params[:store][:City],
       :State_ID => params[:store][:State_ID],
       :Street => params[:store][:Street],
       :ZIP => params[:store][:ZIP],
       :Phone => params[:store][:Phone],
       :Web => params[:store][:Web],
       :Email => params[:store][:Email],
       :PartnerID => @partner.id,
       :IsDefault => 1
      )
     else
       @store.update_attributes(:Name => params[:store][:Name],
         :City => params[:store][:City],
         :State_ID => params[:store][:State_ID],
         :Street => params[:store][:Street],
         :ZIP => params[:store][:ZIP],
         :Phone => params[:store][:Phone],
         :Web => params[:store][:Web],
         :Email => params[:store][:Email],
         :IsDefault => true)
     end

     if @partner.update_attributes(
        :Password => @newpassword.blank? ? @partner.Password : PasswordUtilities.hash(params[:newpassword]),
        :Address => params[:partner][:Address],
        :City => params[:partner][:City],
        :State_ID => params[:partner][:State_ID],
        :ZIP => params[:partner][:ZIP],
        :PhoneNumber => params[:partner][:PhoneNumber],
        :Email => params[:partner][:Email],
        :WebSite => params[:partner][:WebSite],
        :Description => params[:partner][:Description],
        :BillingName => params[:partner][:BillingName],
        :BillingLastName => params[:partner][:BillingLastName],
        :BillingStreet => params[:partner][:BillingStreet],
        :BillingCity => params[:partner][:BillingCity],
        :BillingState_ID => params[:partner][:BillingState_ID],
        :BillingZIP => params[:partner][:BillingZIP],
        :BillingPhone => params[:partner][:BillingPhone],
        :BillingEmail => params[:partner][:BillingEmail],
        :PaymentSystem => params[:partner][:PaymentSystem],
        :PayPalAccount => params[:partner][:PayPalAccount],
        :Check => params[:partner][:Check],
        :PartnerName => params[:partner][:PartnerName]
        )
          if (@err_oldpassword != '' || @err_newpassword != '')
            @store.valid?
             @partner.valid?
             render
             return
          end
          @newpassword = ''
          @oldpassword = ''
          @passCheck = ''
          @is_saved = true
          reset_partner
     else
       @store.valid?
       @partner.valid?
       render
       return
     end
    end
  end

  #######################################################
  # ATION PARTNERCONFIRM
  #######################################################

  def partnerconfirm
    @email = params[:email]
  end

  #######################################################
  # ATION STORESLIST
  #######################################################

  def storeslist
    @partner = partner
    @stores = Store.find_all_by_PartnerID(@partner.id)
    @stores = (@stores.sort_by { |e| e.id.to_i }).reverse

    #################################
    #Pager
    #################################
    @pager = Pager.new(params[:countP], @stores.length, params[:currentP])
    @stores = Pager.get_array(@pager.page_size, @stores, 1, @pager.offset)
  end

  #######################################################
  # ATION EDITSTORE
  #######################################################
  def editstore
    expire_stores_cache

    @partner = partner

    if params[:id].blank?
      @store = Store.new()
    else
      @store = Store.where(:id => params[:id], :PartnerID => @partner.id).first

      if @store.blank?
        redirect_to :controller => :partner, :action => :storeslist
        return
      end
    end

    @states = StaticDataUtilities.get_states

    if request.post?
      if params[:id].blank?
        @store.PartnerID = session[:partner]
      end

      @store.Name = params[:store][:Name]
      @store.City = params[:store][:City]
      @store.State_ID = params[:store][:State_ID]
      @store.Street = params[:store][:Street]
      @store.ZIP = params[:store][:ZIP]
      @store.Phone = params[:store][:Phone]
      @store.Email = params[:store][:Email]
      @store.IsDefault = params[:store][:IsDefault]
      @store.Category_ID = params[:store][:Category_ID]
      @store.CategoryName = params[:store][:CategoryName]

      if @store.save
        if params[:store][:IsDefault].to_i == 1
          StaticDataUtilities.reset_default_store(@partner.id, @store.id)
        end
        redirect_to :controller => :partner, :action => :storeslist
      else
        return
      end
    else
      unless @store.category.blank?
        @store.CategoryName = @store.category.name
      end
    end

  end

  #######################################################
  # ATION DELETE STORE
  #######################################################
  def delstore
    unless params[:id].blank?
      expire_stores_cache

      @partner = partner
      @store = Store.find(:first, :conditions => ["id = ? AND PartnerID = ?", params[:id], @partner.id])

      if @store.blank?
        redirect_to :controller => :partner, :action => :storeslist
        return
      end

      @store.update_attribute(:IsDeleted, true)
    end

    redirect_to :controller => :partner, :action => :storeslist
    return
  end

  #######################################################
  # ATION DELETE STORE
  #######################################################
  def deladministrator
    unless params[:id].blank?
      @partner = partner
      @administrator = PartnerAdministrator.find(:first, :conditions => ["id = ? AND Partner_ID = ?", params[:id], @partner.id])

      if @administrator.blank?
        redirect_to :controller => :partner, :action => :administrators
        return
      end

      @administrator.update_attribute(:IsDeleted, true)
    end

    redirect_to :controller => :partner, :action => :administrators
    return
  end

  #######################################################
  # ATION PRODUCT LIST
  #######################################################


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
    render :text => Store.get_csv(partner.id)
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
    template = ProductParam.find(params[:id])
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
  def getvalues
    template = ProductParam.find(params[:id])
    unless template.blank?
      values = template.value_params
      render :json => values
      return
    else
      render :json => nil
      return
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

  ##############################################
  # ACTION ORDERS
  ##############################################
  def orders
    #--------------------------
    #  Get records
    #--------------------------
    @partner = partner

    @stores = StaticDataUtilities.get_stores_by_partner_select(@partner.id)
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
    end

    @orders = @partner.orders


    @orders = (@orders.sort_by { |e| e.id.to_i  }).reverse

    #################################
    #Search
    #################################

    @orders = @filter.filter(@orders, @partner.id)

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
  # ACTION ORDER
  ##############################################
  def order
    if !params[:id].blank?
      @partner = partner

      count_order = (@partner.orders.find_all {|o| o.id.to_i == params[:id].to_i}).length

      if count_order == 0
        redirect_to :controller => :partner, :action => :orders
        return
      end

      @order = Order.find(params[:id])

      if request.post?
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

          redirect_to :controller => :partner, :action => :orders
          return
        end
      end


      @order_statuses = StaticDataUtilities.get_list_order_status
      @order_statuses.delete_if {|o| o.id == OrdersStatus::STATUSES.invert['Closed']}

      @line_statuses = LineStatus.find(:all)

      @shipping_methods = StaticDataUtilities.get_shipping_method_select

      @shipment_cost = 0

    else
      redirect_to :controller => :partner, :action => :orders
      return
    end
  end

  ##############################################
  # ACTION KNACK PAYMENTS
  ##############################################
  def knackpayments
    @partner = partner

    @payments = KnackPayment.get_partner_payments(@partner.id, params[:o2pid], params[:o2r2pid])
      #redirect_to :controller => :partner, :action => :order, :id => params[:oid]
      #return


    @statuses = StaticDataUtilities.get_order_status_select


    #################################
    #Filter
    #################################
    @filter = FilterPayments.new()

    if request.post?
      @filter.payment_id = params[:filter][:payment_id]
      @filter.status_id = params[:filter][:status_id].to_i
      @filter.datepicker_from = params[:filter][:datepicker_from]
      @filter.datepicker_to = params[:filter][:datepicker_to]
      @filter.payment_amount_from = params[:filter][:payment_amount_from]
      @filter.payment_amount_to = params[:filter][:payment_amount_to]
    end

    #################################
    #Search
    #################################

    @payments = @filter.filter(@payments, @partner.id)

    #################################
    #Pager
    #################################
    @pager = Pager.new(params[:countP], @payments.length, params[:currentP])

    #################################
    #Sort
    #################################

    @payments = @filter.pager(@payments, @pager.offset, @pager.page_size)
  end
end
