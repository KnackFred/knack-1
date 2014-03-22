class PayPalController < ApplicationController
  
  
  require "active_merchant"
  require 'net/https'
  require 'uri'

  def checkout
    setup_response =  gateway.setup_purchase(params[:amount].to_i,
      :ip                => request.remote_ip,
      :return_url        => url_for(:action => :confirm, :only_path => false,
        :amount => params[:amount], :g => params[:g]),
      :cancel_return_url => url_for(:controller => :payment, :action => :error_payment, :r => "Error payment", :only_path => false),
      :description       => "Purchase On Knack"
    )
  
    redirect_to gateway.redirect_url_for(setup_response.token)
    
  end  

  def error
    
  end

  def confirm
    redirect_to :controller => :payment, :action => :error_payment, :r => "Error payment" unless params[:token]

    details_response = gateway.details_for(params[:token])

    if !details_response.success?
      @message = details_response.message
      render :controller => :payment, :action => :error_payment, :r => "Error payment"
      return
    end

    @address = details_response.address

  end

  def complete

    purchase = gateway.purchase(params[:amount].to_i,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )

    if !purchase.success?
      @message = purchase.message
      render :controller => :payment, :action => :error_payment, :r => "Error payment"
      return
    end

    payment = Payment.new(:PaymentType_ID => 1,
        :IsTakeMoney => 0,
        :PaymentStatus => purchase.params["payment_status"],
        :PaymentDate => purchase.params["payment_date"],
        :TransactionID => purchase.params["transaction_id"],
        :FeeAmount => purchase.params["fee_amount"],
        :GrossAmount => purchase.params["gross_amount"])

    if payment.save
      redirect_to  :controller => :payment ,:action => :success_payment, :guid => params[:g], :p => payment.id
    end

  end

  def send_masspay
    if !params[:amount].blank? && !params[:email].blank? && !params[:g].blank?
      subject = params[:subject].blank? ? '' : params[:subject]
      note = params[:note].blank? ? '' : params[:note]
      response = gatewayMass.transfer(params[:amount].to_i, params[:email],
        :subject => subject, :note => note)
      if response.success?
        payment = Payment.new(:PaymentType_ID => 1,
            :IsTakeMoney => 0,
            :PaymentStatus => response.message,
            :PaymentDate => response.params["timestamp"],
            :GrossAmount => params[:amount])
        if payment.save
          redirect_to  :controller => :payment ,:action => :success_payment, :guid => params[:g], :p => payment.id
          return
        end
      end
    end
    @message = "error payments"
    render :controller => :payment, :action => :error_payment, :r => "Error payment"
  end

  private
  def gateway
    #ActiveMerchant::Billing::Base.mode = :test
    @gateway ||= ActiveMerchant::Billing::PaypalExpressGateway.new(
      :login => LOGIN,
      :password => PASSWORD,
      :signature => SIGNATURE
    )
    
  end

  def gatewayMass
    #ActiveMerchant::Billing::Base.mode = :test
    @gateway ||= ActiveMerchant::Billing::PaypalGateway.new(
      :login => LOGIN,
      :password => PASSWORD,
      :signature => SIGNATURE
    )
  end



  def self.send_money(to_email, how_much_in_cents, options = {})
    credentials = {
      "USER" => 'test3p_1283330367_biz_api1.gmail.com',
      "PWD" => '1283330396',
      "SIGNATURE" => 'ALuzWFORgCeJKWLWNAwV5IcGeBlyA8X3gWzYAL6IX.DCZ7CF2.CC7lvs',
    }

    params = {
      "METHOD" => "MassPay",
      "CURRENCYCODE" => "USD",
      "RECEIVERTYPE" => "EmailAddress",
      "L_EMAIL0" => to_email,
      "L_AMT0" => ((how_much_in_cents.to_i)/100.to_f).to_s,
      "VERSION" => "51.0"
    }

    endpoint = Rails.env == 'production' ? "https://api-3t.paypal.com" : "https://api-3t.sandbox.paypal.com"
    url = URI.parse(endpoint)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    all_params = credentials.merge(params)
    stringified_params = all_params.collect { |tuple| "#{tuple.first}=#{CGI.escape(tuple.last)}" }.join("&")

    response = http.post("/nvp", stringified_params)
  end

#  PAYPAL_END_POINT_URL_TEST = "https://api-3t.sandbox.paypal.com/nvp"
#  LOGIN = "test3p_1283330367_biz_api1.gmail.com"
#  PASSWORD = "1283330396"
#  SIGNATURE = "ALuzWFORgCeJKWLWNAwV5IcGeBlyA8X3gWzYAL6IX.DCZ7CF2.CC7lvs"

  PAYPAL_END_POINT_URL_TEST = "https://api-3t.sandbox.paypal.com/nvp"
  LOGIN = "fred_api1.knackregistry.com"
  PASSWORD = "D6WW2ER3HHC8PTZL"
  SIGNATURE = "AFcWxV21C7fd0v3bYYYRCpSSRl31AEHLpUg1OUSEP68EyMQLlDZz2fPO"

  # needs an array of hashes to be passed as the users list
  # ------------------------Example------------------------------------------------
  #user_1 = {:email=>"buyer_1254479426_per_1257321861_per@XXXXX.com",
  #          :amount=>10, :unique_id=>"020484", :note=>"Heres your money"}
  #user_2={:email=>"buyer2_1254493228_per@XXXXX.com", :amount=>10,
  #         :unique_id=>"270484", :note=>"more money for you"}
  #user_list = [user_1, user_2]
  #setup_payment (user_list)
  #----------------------------------------------------------------------------------

  def setup_payment(user_list)
    response = nil
    header = {"Content-Type"=>"application/x-www-form-urlencoded"}
    email_subject = URI.escape("Payment Notification")
    receiver_type =URI.escape("EmailAddress")
    currency = URI.escape("USD")
    version = URI.escape("56")
    method =URI.escape("MassPay")
    end_point_url = paypal_end_point
    user_information =  payable_info(user_list)
     final_url_string = "#{end_point_url}?METHOD=#{method}" +
          "&PWD=#{PASSWORD}" +
          "&USER=#{LOGIN}" +
           "&SIGNATURE=#{SIGNATURE}"+
            "&VERSION=#{version}"+
            "&EMAILSUBJECT=#{email_subject}"+
             "&CURRENCYCODE=#{currency}"+
             "&RECEIVERTYPE=#{receiver_type}"+
              "#{user_information}"

 #       SystemTimer.timeout_after(20.seconds) do
          uri = URI.parse(final_url_string)
#          http = Net::HTTP.new(uri.host, uri.port)
#          http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
#          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          response = Net::HTTP.post_form(uri)
          a = 1
#          http.start {
#
##            http.request_get(uri.path) {|res|
##              #print res.body
##              a = 1
##            }
#          }
          #response = open(final_url_string)
 #       end

  rescue OpenURI::HTTPError => error
   status_code = error.io.status[0]
   Rails.logger.debug "[ERROR][Paypal] #{error.message }  :  #{error.backtrace} "
  rescue Timeout::Error=>time_out_error
   Rails.logger.debug "[ERROR][Timeout Error] #{time_out_error.message} : #{time_out_error.backtrace}"
  rescue =>err
   Rails.logger.debug "[ERROR][Something went wrong] #{err.message} : #{err.backtrace}"
  end

  #accepts an array of hash
  def payable_info(user_values)
    final_url_string=""
    array_size = user_values.size - 1
      0.upto(array_size) do  |index|
       final_url_string += "&L_EMAIL" + index.to_s + "=#{URI.escape(user_values[index][:email])}"
       final_url_string += "&L_AMT" + index.to_s + "=#{(user_values[index][:amount])}"
       final_url_string += "&L_UNIQUEID" + index.to_s + "=#{URI.escape(user_values[index][:unique_id])}"
       final_url_string += "&L_NOTE" + index.to_s + "=#{URI.escape(user_values[index][:note])}"
     end
     final_url_string
  end

  # defines the paypal_end_point
  def paypal_end_point
    (Rails.env == 'development') ? PAYPAL_END_POINT_URL_TEST : "something else"
  end

end
