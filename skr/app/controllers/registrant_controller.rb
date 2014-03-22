require 'mail_utilities'
require 'cart'
require 'math_utilite'
require 'uri'
require 'net/http'
class RegistrantController < ApplicationController

  def upload_image
    @registrant = registrant
    unless request.get?
      @call = "upload_image"
      if @registrant.update_attributes(params[:registrant])
        @status = "true"
        @param = "/registrant/crop_image"
      else
        @status = "false"
        @param = "The image must be a JPG, JPEG or PNG under 3 MB."
      end
      render 'shared/close_modal', :layout => "empty"
      return
    end
    render 'shared/upload_image', :layout => "empty", :locals => {:model => @registrant,  :attachment => :profile_image}
  end

  def crop_image
    @registrant = registrant
    unless request.get?
      @call = "crop_image"
      if @registrant.update_attributes(params[:registrant])
        @status = "true"
        @param = @registrant.profile_image.url(:large)
      else
        @status = "false"
        @param = @registrant.errors.to_s
      end
      render 'shared/close_modal', :layout => "empty"
      return
    end
    render 'shared/crop_image', :layout => "empty", :locals => {:model => @registrant,  :attachment => :profile_image, :action => "crop_image"}
  end

  def crop_product_image
    product = registrant.owned_products.find(params[:id])
    unless request.get?
      @call = "crop_image"
      if product.update_attributes(params[:product])
        @status = "true"
        @param = '/manage_registry'
      else
        @status = "false"
        @param = product.errors.to_s
      end
      render 'shared/close_modal', :layout => "empty"
      return
    end
    render 'shared/crop_image', :layout => "empty", :locals => {:model => product,  :attachment => :main_product_thumb, :action => "crop_product_image"}
  end


  #######################################################
  # Action HOME
  #######################################################
  def home
    render :home, :layout => "application"
  end

  #######################################################
  # Action HOME2 used for A/B Testing
  #######################################################
  def home2
    render :home2, :layout => "application"
  end

  #######################################################
  # Action HOME
  #######################################################
  def activation
    @registrant = Registrant.activate params[:id]
    unless @registrant.blank?
      MailUtilities.send_activated(@registrant.Email, @registrant.Email)
    end
  end

  #######################################################
  # Action confirm
  #######################################################
  def confirm
    @email = params[:email]
  end

  #######################################################
  # Action GIVE
  #######################################################
  def give
    @registry = ''

    unless params[:find].blank?
      @isPost = 1

      @registry = params[:find].blank? ? '' : params[:find].to_s

      @registrants = Registrant.search(@registry, params[:page], 10)
    end
  end

  #######################################################
  # Action list_registries_for_google
  #######################################################
  def list_registries_for_google
    @registrants = Registrant.active.paginate(:page => params[:page])
  end

  #######################################################
  # Action MANAGE REGISTRY
  #######################################################
  def manage_registry

    # Do not cache this page.
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

    @registrant = registrant

    sort = (params[:sort] || 0).to_i
    filter = (params[:filter] || "0").to_i

    manage_registry_params = ManageRegistryParams.new(params[:page], nil, sort, filter)

    if request.post? && !params[:back_view].blank?
      unless session[:manage_registry_params].blank?
        manage_registry_params = session[:manage_registry_params]
      end
    end
    session[:manage_registry_params] = manage_registry_params
    session[:back_path] = manage_registry_path(:filter => manage_registry_params.filter, :sort => manage_registry_params.sort, :page => manage_registry_params.page)

    @registrant2products = registrant.gifts(manage_registry_params.filter, manage_registry_params.page, manage_registry_params.per_page, manage_registry_params.sort)

  end

  #######################################################
  # Action update_all_external
  #######################################################
  def update_external
    @valid = true
    @products = registrant.registry_items.not_catalog.editable.collect do |item|
      item.product
    end
    unless request.get?
      if params[:products].blank?
        @products = []
        @valid = true
        return
      end
      params[:products].keys.each do |id|
        prod = Product.find(id)
        raise ActiveRecord::RecordNotFound if prod.Registrant_ID != registrant.id
      end

      @products = Product.update(params[:products].keys, params[:products].values)
      @products.each do |p|
        @valid = false unless p.errors.empty?
      end

      if @valid
        flash.notice = "Changes Saved"
        redirect_to "/registrant/update_external"
      end
    end
  end

  #######################################################
  # Action ViewAll
  #######################################################
  def viewall
    @transactions = Transactions.get_transactions(session[:registrant])

    @registrant = registrant

    #################################
    #Pager
    #################################
    @pager = Pager.new(params[:countP], @transactions.length, params[:currentP])
    @transactions = Pager.get_array(@pager.page_size, @transactions, 1, @pager.offset)
  end

  #######################################################
  # Action AddGift
  #######################################################
  def addgift
    @registrant = registrant
    @is_new = !params[:new_user].blank?
  end

  #######################################################
  # Action ADDMYOWNGIFT
  #######################################################
  def addmyowngift

    if request.post?
      @item = RegistryItem.new(params[:registry_item])
      @item.registrant = registrant
      @item.Price = @item.product.MasterPrice
      @item.Purchased_ID = RegistryItem::AVAILABLE

      @item.product.creator = registrant

      if @item.save
        @status = true
        @call = @item.product.stock_image.blank? ? "addmyowngift" : "crop_image"
        @param = @item.product.stock_image.blank? ? "/registrant/crop_product_image/#{@item.product.id}" : "/manage_registry"
        render 'shared/close_modal', :layout => false
        return
      end
    else
      @item = RegistryItem.new
      @item.product = Product.new(:MasterPrice => 1)
    end

    render :addmyowngift, :layout => 'empty'
  end

  #######################################################
  # Action DOWNLOADTOOL
  #######################################################
  def downloadtool
    @registrant = registrant

    @browsers = [
        Browsers.new(1, 'Internet Explorer', 'toolbar_ie'),
        Browsers.new(2, 'Chrome', 'toolbar_cr'),
        Browsers.new(3, 'Firefox', 'toolbar_ff'),
        Browsers.new(4, 'Safari', 'toolbar_safari')
    ]
    @browser = @browsers.first
    if !params[:browser].blank? && !params[:browser][:id].blank?
      @browser = @browsers.find{|b| b.id == params[:browser][:id].to_i}
    end

    render :downloadtool, :layout => 'empty'
  end

  #######################################################
  # Action REGISTRY
  #######################################################
  def registry
    if session[:registrant]
      @registrant = registrant
    end
    @registry = Registrant.includes(:sections, :registry_items => [:product, :contributes]).find_by_id_and_IsDeleted(params[:id], false)

    if @registry.blank?
      redirect_to :controller => :registrant, :action => :give
      return
    end

    session[:back_path]=registry_path(:id => @registry.id)

    if request.put? && @registrant == @registry
      if @registry.update_attributes(params[:registrant])
        # If something was moved to a newly create section update attributes will not automatically deal with it.
        unless params["registrant"]["registry_items_attributes"].blank?
          params["registrant"]["registry_items_attributes"].each_value do |i|
            if i["section_id"] == ""
              reg_item = RegistryItem.find(i["id"])
              reg_item.section = @registry.sections.where(:order => i["section_order"]).first
              reg_item.save
            end
          end
        end
        reset_registrant
        redirect_to :action => :registry, :id => params[:id]
      end
    end

    if @registrant.nil? # When viewing a registry as a not logged in user remove the nav bar.
      session[:full_nav] = false
    end
  end

  #######################################################
  # Action EDIT REGISTRY ITEM
  #######################################################
  def edit_registry_item
    @reg_item = registrant.registry_items.find(params[:id])
    raise "Item not found" if @reg_item.nil? || @reg_item.IsDeleted?

    if request.put?
      unless @reg_item.update_attributes(params[:registry_item])
        render :layout => "buy", :status => :bad_request
        return
      end
      product_params = params[:product_params]

      unless product_params.blank?
        @reg_item.reset_params(product_params)
      end

      @status = 5
      @param = @reg_item.id
      render 'shared/close_modal', :layout => false

    else
      render :layout => "buy"
    end
  end

  def invited_signup
    @registrant = registrant
  end

  #######################################################
  # Action DELETER2P
  #######################################################
  def delete_registry_item
    registry_item = RegistryItem.find(params[:id])

    if registry_item.blank?
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::NOT_FOUND
      return
    end

    unless registry_item.Contributed == 0
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::CUSTOM, :message => 'You can not delete an item that has been contributed to.'
      return
    end

    if registry_item.delete_from_registry
      @status = 4
      @param = 0
      render 'shared/close_modal', :layout => false
    else
      redirect_to :controller => :buy, :action => :errorpage, :id => ErrorMessages::DIFFERENT
    end
  end

  #######################################################
  # Action LOGIN
  #######################################################
  def login
    if ( cookies[:remember_me_id] )
      registrant = Registrant.sign_in_remember_me cookies[:remember_me_id], cookies[:remember_me_code]

      if !registrant.nil?
        populate_session registrant, false
        redirect_to :controller => :registrant, :action => :manage_registry
        return
      else
        cookies.delete :remember_me_id
        redirect_to :action => :home
        return
      end
    end

    if request.post?
      @err_email = ''
      @err_pass = ''
      @err_general = ''

      if params[:registrant][:Email].blank?
        @err_email = StaticDataUtilities.get_prepare_error_message + "can't be blank"
      end
      if params[:registrant][:Password].blank?
        @err_pass = StaticDataUtilities.get_prepare_error_message + "can't be blank"
      end

      if(@err_email != '' || @err_pass != '')
        return
      end
      begin
        registrant = Registrant.sign_in(params['registrant'][:Email], params['registrant'][:Password])
        populate_session registrant, params[:rememberMe]
        redirect_to get_login_url(registrant, false)
      rescue
        @err_general = $!.message
      end
    end
  end

  #######################################################
  # Action populate_session
  #######################################################
  def populate_session (registrant, remember_me)
    session[:registrant] = nil
    session[:partner] = nil
    session[:administrator] = nil
    session[:knack] = nil

    if remember_me
      user_id = (registrant.id).to_s
      cookies[:remember_me_id] = { :value => user_id, :expires => 30.days.from_now }
      user_code = Digest::SHA1.hexdigest( registrant.Email )[4,18]
      cookies[:remember_me_code] = { :value => user_code, :expires => 30.days.from_now }
    end

    session[:registrant]= registrant.id

    session[:cart] = Cart.new()
  end

  #######################################################
  # Action LOGOUT
  #######################################################
  def logout
    session[:registrant] = nil
    session[:cart] = nil

    if cookies[:remember_me_id] then
      cookies.delete :remember_me_id
    end
    if cookies[:remember_me_code] then
      cookies.delete :remember_me_code
    end
    redirect_to :controller => :registrant,:action => :home
  end

  #######################################################
  # Action REGISTER
  #######################################################
  def register
    @states = StaticDataUtilities.get_states false

    if request.post?

      @registrant = Registrant.new("Email"=>params['registrant'][:Email],
                                   "new_password"=> params['registrant'][:new_password],
                                   "FirstName"=>params['registrant'][:FirstName],
                                   "LastName"=>params['registrant'][:LastName],
                                   :State_ID=>params['registrant'][:State_ID])

      if @registrant.save
        MailUtilities.send_welcome(@registrant.Email)

        populate_session @registrant, nil
        redirect_to get_login_url @registrant, true, params['registrant'][:Email]
        return
      else
        @registrant.new_password = ""
      end
    end
  end

  #######################################################
  # Action REGISTER FACEBOOK USER
  #######################################################
  def registerfb
    begin
      if Registrant.fb_exists(params[:fbuid])
        #  Do Nothing
      elsif Registrant.email_exists(params[:Email])
        registrant = Registrant.where(:Email => params[:Email], :IsDeleted => false).first()
        # Update Attribute is used here because we need to skip validation in case the user has not yet finished filling out the profile.
        registrant.update_attribute(:fbuid, params[:fbuid])
      elsif !params[:fbuid].blank?
        state_name = params[:Location].split(', ')[-1]
        state = State.find_by_Name(state_name)
        state_id = state.nil? ? State.find_by_Name("California").id : state.id
        city = params[:Location].split(', ')[0]
        registrant = Registrant.create!(
            :Email     => params[:Email],
            :fbuid     => params[:fbuid],
            :FirstName => params[:FirstName],
            :LastName  => params[:LastName],
            :IsActivated => 1,
            :State_ID => state_id,
            :City => city,
            :new_password	=>	"75923hsad",
            :is_invited => params[:is_invited]  )
        MailUtilities.send_welcome(params[:Email])
        is_new = true
      end

      registrant = Registrant.sign_in_fb(params[:fbuid])
      populate_session(registrant, false)

      render :json => {:url => get_login_url(registrant, is_new)}
    rescue => e
      notify_airbrake(e) unless e.message == 'User Not Found'
      render :text => e.message, :status => :unauthorized
    end
  end

  #######################################################
  # Action PROFILE
  #######################################################
  def profile
    @registrant = registrant

    @states = StaticDataUtilities.get_states false
    @types = StaticDataUtilities.get_registrant_type

    unless request.get?
      if @registrant.update_attributes(params[:registrant])
        reset_registrant
        flash[:success] = "Your changes have been saved."
        redirect_to profile_path
      end
    end
  end

  def savepaymentsystem
    @registrant = registrant
    @paymentNumber = params[:registrant][:PaymentSystem]
    if !@paymentNumber.blank?
      if @registrant.update_attribute("PaymentSystem",@paymentNumber)
        redirect_to :controller => :registrant, :action => :profile
      end
    end
  end

  #######################################################
  # Action ADD_TO_REGISTRANT
  #######################################################

  def add_from_registry
    @orig_item_id = params[:id]
    orig_item = RegistryItem.find(params[:id])
    raise ActiveRecord::RecordNotFound if orig_item.nil? || orig_item.IsDeleted?
    @reg_item = orig_item

    unless orig_item.product.available?
      @reg_item.errors[:product] << "This product is not longer available from Knack, and can not be added to new registries"
      render :layout => "buy", :status => 400
      return
    end

    unless request.get?
      @reg_item = orig_item.duplicate(registrant)

      prod_params = params['registry_item'].delete("product_attributes")

      unless orig_item.product.catalog?
        @reg_item.product.attributes = prod_params
      end
      @reg_item.attributes = params['registry_item']

      if @reg_item.save
        @reg_item.reset_params(params[:product_params])
        render 'shared/modal_message', :layout => "empty", :locals => {:message => "The gift has been added to your registry"}
        return
      else
        render :layout => "buy", :status => 400
        return
      end
    end

    render :layout => "buy"
  end

  def add_to_registrant
    quantity = params[:quantity].blank? ? 1 : params[:quantity]
    color_id = params[:color_id].blank? ? nil : params[:color_id]
    product = Product.find(params[:pid])

    if product.IsKind
      expire_brands_cache
      product.update_attributes(:IsKindView => false)
    end

    tax = product.tax(registrant.State_ID) || 0
    shipment = product.Shipment || 0

    r2p = RegistryItem.new(:Product_ID => params[:pid], :Registrant_ID => session[:registrant],
                           :Price => product.Price, :Quantity => quantity, :Purchased_ID => 2,
                           :Color_ID => color_id, :Tax => tax, :Shipment => shipment)

    if r2p.save
      pp = ActiveSupport::JSON.decode(params[:product_params])

      params = BuyProduct.parse_params(pp)

      params.each do |p|
        p.registry_item_id = r2p.id
        p.save
      end
      render :text => 2
    else
      render :text => 1
    end
  end

  #######################################################
  # ACTION FORGOT PASSWORD
  #######################################################
  def forgotpassword
    if request.post?
      @erremail = ''
      if params[:registrant][:Email].blank?
        @err_email = StaticDataUtilities.get_prepare_error_message + "Please enter an email address."
        return
      end

      @registrant = Registrant.email_exists(email = params[:registrant][:Email])

      if @registrant.blank?
        @err_email = StaticDataUtilities.get_prepare_error_message + "No matching email address was found."
        return
      end

      unless @registrant.fbuid.nil?
        @err_email = StaticDataUtilities.get_prepare_error_message + "This email belongs to a Facebook account.  Please log-in using the facebook log-in button."
        return
      end

      MailUtilities.send_reset_password(@registrant)
      @email_sent = 2

    else
      unless params[:id].blank?
        @registrant = Registrant.where("ImageGUID = ? AND IsDeleted = 0", params[:id]).first()
        if !@registrant.blank?
          new_password = @registrant.reset_password
          MailUtilities.send_forgot_password(@registrant, new_password)
          @email_sent = 1
        else
          @err_email = StaticDataUtilities.get_prepare_error_message + "We were unable to reset you password please try again."
          return
        end
      end
    end
  end

  #######################################################
  # ACTION LINKS
  #######################################################
  def links

    id = session[:registrant]

    @registrant = registrant

    gift_count = registrant.gifts_count(RegistryItem::AVAILABLE)

    @banners = Array.new()
    @banners_src = Array.new()

    framewidth = 0
    frameheight = 0

    4.times do |i|

      case i
        when 0 then
          framewidth = 271
          frameheight = 81
        when 1 then
          framewidth = 141
          frameheight = 351
        when 2 then
          framewidth = 271
          frameheight = 161
        when 3 then
          framewidth = 411
          frameheight = 101

      end

      base_url = ::APP_CONFIG['base_url']

      banner_src = "<iframe scrolling='no' resizable='no' width='" + framewidth.to_s + "' height='" + frameheight.to_s + "' src='" + base_url + "registrant/getbanner?r=" + id.to_s + "&n=" + i.to_s + "'></iframe>"
      @banners_src << banner_src

      banner = banner_html(i, gift_count, false)
      @banners << banner

    end

  end

  def getbanner
    registrant = Registrant.find(params[:r])
    gift_count = registrant.gifts_count(RegistryItem::AVAILABLE)

    banner_content = banner_html(params[:n].to_i, gift_count, true, registrant.id)

    send_data(banner_content, :type => 'text/html', :disposition => 'inline')

  end



  #######################################################
  # returns the html for the banner
  #######################################################

  def banner_html (banner_id, gift_count, link = true, registrant_id = 0)
    case banner_id
      when 0 then
        image = 'images/banners/banner271x81.png'
        top = '48px'
        left = '185px'
      when 1 then
        image = 'images/banners/banner141x351.png'
        top = '168px'
        left = '50px'
      when 2 then
        image = 'images/banners/banner271x161.png'
        top = '73px'
        left = '130px'
      else # it must be 3.
        image = 'images/banners/banner411x101.png'
        top = '66px'
        left = '130px'
    end
    base_url = ::APP_CONFIG['base_url']

    if link
      return "<html><head></head><body style='margin:0px;'>" +
          "<a alt='' style='text-decoration:none!important;' href=" + base_url + "registry/" + registrant_id.to_s + " target='top'>" +
          "<img alt=''  style='border:0px;' src='" + base_url + image + "'/>" +
          "<div style='position:absolute;top:" + top + ";left:" + left + ";'><span style='text-decoration:none!important; color:#666666; font-weight:bold; font-size: 1opt;'>" + gift_count.to_s + " " + ((gift_count == 1) ? "gift" : "gifts") + ".</span></div></a></body></html>"

    else
      return "<html><head></head><body style='margin:0px;'>" +
          "<a alt='' style='text-decoration:none!important;'>" +
          "<img alt=''  style='border:0px;' src='" + base_url + image + "'/>" +
          "<div style='position:absolute;top:" + top + ";left:" + left + ";'><span style='text-decoration:none!important; color:#666666; font-weight:bold; font-size: 10pt;'>" + gift_count.to_s + " " + ((gift_count == 1) ? "gift" : "gifts") + ".</span></div></a></body></html>"

    end
  end

  #######################################################
  # ACTION External add my own gift
  #######################################################
  def extaddgift
    begin
      registrant_id = params[:r]
      registrant = Registrant.find(registrant_id)

      title = params[:t].slice(0, 50)
      description = params[:d].slice(0, 900)

      ext_color = params[:ec].slice(0, 50)
      ext_size = params[:es].slice(0, 50)
      ext_other = params[:eo].slice(0, 50)

      price = params[:p]
      quantity = params[:q]
      image_url = params[:i]
      source_url = params[:s]
      source_name = params[:n]
      section_id = params[:sec]

      image = ImageUtilities.get_image_by_url(image_url)
      image = open("public/images/defaultImage.png") if image.blank?
      section_id = nil unless Section.exists?(section_id)

      product = Product.create!(
          :Name => title,
          :MasterPrice => price,
          :main_product_image => image,
          :Description => description,
          :ProductStatus_ID => 3,
          :Registrant_ID => registrant_id,
          :source_url => source_url,
          :source_name => source_name,
          :ext_color => ext_color,
          :ext_size => ext_size,
          :ext_other => ext_other,
          :external => true

      )

      product.registry_items.create!(
          :Registrant_ID => registrant_id,
          :Price => price,
          :Quantity => quantity,
          :Purchased_ID => 2,
          :Shipment => 0,
          :IsToolbar => true,
          :section_id => section_id
      )
      render :text => 'knackGetAddRequest("0");'
    rescue
      render :text => 'knackGetAddRequest("1");'
      return
    end

  end

  #######################################################
  # ACTION External get sections
  #######################################################
  def ext_sections
    registrant_id = params[:id]

    #---------------------------
    #- Calculate tax
    #---------------------------
    registrant = Registrant.find(registrant_id)

    render :text => 'knackLoadSections('+registrant.sections.to_json(:only => [:id, :title])+');'
  end

  private

  #######################################################
  # METHOD PAGER
  #######################################################
  def pager(offset, page_size)
    if @registrant2products.length > 0
      @registrant2products = Pager.array_mod(@registrant2products, 1, offset)
      @registrant2products = @registrant2products.first(page_size)
    end
  end

  def get_login_url(registrant, is_new, new_email = "facebook")
    if is_new
      url_for :action => :addgift, :new_user => new_email, :only_path => true
    else
      if session[:intended_path].blank?
        if registrant.invite_friends_shown?
          url_for :controller => :registrant, :action => :manage_registry, :only_path => true
        else
          registrant.update_attribute(:invite_friends_shown, true)
          url_for :controller => :follows, :action => :index, :only_path => true
        end
      else
        path = session[:intended_path]
        session[:intended_path] = nil
        path
      end
    end
  end

end
