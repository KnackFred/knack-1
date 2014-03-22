# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery #:only => [:create, :update, :destroy]

  def registrant
    @current_user ||= Registrant.find(session[:registrant]) unless session[:registrant].blank?
  end

  def partner
    @current_partner ||= Partner.find(session[:partner]) unless session[:partner].blank?
  end

  def administrator
    @current_partner ||= Partner.find(session[:knack]) unless session[:knack].blank?
  end

  def reset_registrant
    @current_user = nil
    registrant
  end

  def reset_partner
    @current_partner = nil
    partner
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    rescue_from Exceptions::AccessDenied,             :with => :render_access_denied
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def check_out
    controller = self.params[:controller]
    case controller
      when "admin/products"
        check_admin()
      when "admin/partner_administrators"
        check_admin()
      when "partner"
        check_partner()
      when "administrative"
        check_administrative()
      else
        check_registrant()
    end
  end

  #=============================================
  #= Check registrant
  #=============================================
  def check_registrant
    if session[:registrant].blank?
      session[:intended_path] = request.env['PATH_INFO']
      redirect_to signin_path
    end
  end

  #=============================================
  #= Check administrator
  #=============================================
  def check_administrative
    if session[:knack].blank?
      redirect_to :controller => :partner, :action => :partnerslogin
    end
  end


  #=============================================
  #= Check partners
  #=============================================
  def check_partner
    if session[:partner].blank?
      redirect_to :controller => :partner, :action => :partnerslogin
    end
  end

  def check_admin
    if session[:partner].blank? && session[:knack].blank?
      redirect_to :controller => :partner, :action => :partnerslogin
    end
  end

  def check_site
    if !session[:registrant].blank?
      registrant = Registrant.find(session[:registrant])
    end
  end

  def check_user
    unless session[:partner].blank?
      partner
    else
      unless session[:knack].blank?
        administrator
        @is_admin = true
      else
        unless session[:registrant].blank?
          registrant
        end
      end
    end
  end

  def full_nav
    session[:full_nav] = true
  end

  before_filter :check_site, :except => [:login, :extaddgift, :ext_sections]

  before_filter :check_out, :except => [:login, :register, :logout, :home, :home2, :home3, :give, :registry,
    :item, :buy, :contribute, :cart, :catalog, :feed, :invited_signup,
    :deletefromcart, :getproduct, :deletefrombuycart,
    :confirm, :getbanner, :emptycart, :registerfb , :forpartners, :policy, :tour, :aboutus, :fees, :forgotpassword , :step1, :step2,
    :step3, :func, :func3, :paypal_success, :paypal_cancel ,:stores , :checkout, :error, :confirm, :complete,
    :error_payment, :payment_interrupted, :process_order, :success_payment, :buy_himself, :buy_ext, :edit_ext_order, :destroy_ext_order, :partnerslogin, :send_masspay , :getimagebanner, :contact,
    :merchantPolicy, :helppage ,:learnmore, :getcost, :partnerregister, :partnerconfirm, :partnerslogout,
    :testimonials, :becomepartner, :howdoeswork, :facebook, :whoisknack, :contest, :san_francisco, :san_francisco_fb, :san_francisco_fb_liked, :getaddimage,
    :getitemimg, :getsaddimg, :getbaddimg, :getregimg, :extaddgift, :errorpage, :ext_sections,
    :bigimage, :testmail, :activation, :some_action, :login_guid, :test_button, :brands,
    :search, :stop, :upload_image, :crop_image, :suggest_products, :list_registries_for_google]

  before_filter :check_user

  before_filter :full_nav, :except => [:registry, :item, :contribute, :cart, :deletefromcart, :getproduct, :deletefrombuycart,
                                       :step1, :step2, :step3, :func, :func3, :paypal_success, :paypal_cancel , :checkout, :error, :confirm, :complete,
                                        :error_payment, :payment_interrupted, :process_order, :success_payment, :buy_himself, :buy_ext, :send_masspay , :getimagebanner, :contact,
                                        :getitemimg, :getsaddimg, :getbaddimg, :getregimg, :errorpage,
                                        :upload_image, :crop_image]

  private

  def render_access_denied(exception)
    Rails.logger.error(exception)
    render :empty => true, :status => 403
  end

  def render_not_found(exception)
    Rails.logger.error(exception)
    render :template => "/error/notfound.html.erb", :status => 404
  end

  def render_error(exception)
    Rails.logger.error(exception)
    notify_airbrake(exception)
    render :template => "/error/error.html.erb", :status => 500
  end

  def expire_brands_cache
    expire_page "/brands"
  end

  def expire_stores_cache
    expire_page "/stores"
  end

  def expire_categories_cache
    expire_fragment(%r{category_nav_.*})
  end
end
