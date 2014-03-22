class Venmo
  attr_reader :session

  def initialize(session = {})
    @session = session
  end

  def venmo_url
    APP_CONFIG['venmo_url']
  end

  def authorize_url(redirect_uri)
    "#{venmo_url}/oauth/authorize?client_id=#{APP_CONFIG['venmo_client_id']}&scope=make_payments&redirect_uri=#{CGI.escape(redirect_uri)}"
  end

  def authorized?
    session[:venmo_access_token].present?
  end

  def store_access_token(access_token)
    session[:venmo_access_token] = access_token if access_token.present?
  end

  def make_payment(amount, email, note = 'Gift')
    params = { :email => email, :amount => amount, :note => note }
    params_string = params.map{ |key, value| "#{key}=#{CGI.escape(value)}" }.join('&')
    response = "#{venmo_url}/payments?#{params_string}".to_uri.post(:access_token => session[:venmo_access_token], :follow_redirects => true)
    unless response.ok?
      raise VenmoError.new(response.body)
    end
  end
end

VenmoError = Class.new(StandardError)
