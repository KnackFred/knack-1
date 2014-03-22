require "pony"

module MailUtilities
  def initialize

  end

  def self.sendtest(to)
    id = 123456789
    k = ''
    for i in 0..5
      k += "#{i}<br/>
      "
    end
    Pony.mail(:to => 'john@knackregistry.com',
    :from => get_from_mail,
    :via => :smtp,
    :subject => 'registration1',
    :attachments => {"logo.gif" => ImageUtilities.get_logo_image},
    :html_body => '<img src="cid:attachment" alt="logo">
    Welcome to Knack. Your account has been activated.
      To login, visit',
    :via_options => get_mail_option)
  end

  def self.send(to, subject, body)
    begin
      if ::APP_CONFIG['use_test_email_address']
        to = ::APP_CONFIG['test_email_address_for_send']
      end

      Pony.mail(:to => to,
        :via => :smtp,
        :from => get_from_mail,
        :subject => subject,
        :html_body => body,
        :via_options => get_mail_option)
    rescue => e
      Airbrake.notify e
    end
  end

  #-----------------------------------------
  # send mail activation
  #-----------------------------------------
  def self.send_welcome(to)
    subject = "Welcome To Knack!"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Welcome to Knack, you have joined a growing community of couples creating amazing registries that support small businesses.  We can't wait to see what you'll build!
    <br/><br/>
    You may have some questions about how Knack works.  If you do, please take a look at <a href='https://knackregistry.com/info/tour'>our tour</a>.  Also feel free to contact us at any time at <a href='mailto:support@knackregistry.com'>support@knackregistry.com</a>, we are always happy to talk.
    <br/><br/>
    The next step is creating your registry.  Our catalog offers a variety of items from our small business partners including kitchenware, housewares, furniture and art.
    <br/><br/>
    Not seeing something you want in our catalog?  You can use Knack's gift list tool to add items from any site on the Internet.  So you know you'll be able to register for all the gifts you want.
    <br/><br/>
    You can also use Knack to register for your honeymoon, your new home, or experiences like cooking classes.  You can use our add item tool to add these items to your registry.
    <br/><br/>
    Congratulations on your engagement, and have fun creating your registry with Knack.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(to, subject, body)
  end

  #-----------------------------------------
  # send mail canceled payment
  #-----------------------------------------
  def self.send_cancel_payment(order)
    subject = "Order Canceled"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Your knack order #{order.id} has been canceled
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(order.BillingEmail, subject, body)
  end

  #-----------------------------------------
  # send mail canceled payment
  #-----------------------------------------
  def self.send_money_back(payment)
    subject = "Money back"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Order #{payment.order.id} has been canceled.
    <br/><br/>
    $#{payment.amount} has been refunded to your #{payment.typepayment.Name} account.
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(payment.order.BillingEmail, subject, body)
  end

  #-----------------------------------------
  # send mail activation partner
  #-----------------------------------------
  def self.send_activation_partner(to, guid)
    subject = "Thank you for Registering, Please confirm your Email address!"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Welcome to Knack!
    <br/><br/>
    Please click on the link below to confirm your email address.
    <br/><br/>
    <a href='https://knackregistry.com/partner/activation/#{guid}'>Activate Now</a>
    <br/><br/>
    If you are unable to click on the link, copy and paste the url below into your web browser.
    <br/><br/>
    https://knackregistry.com/partner/activation/#{guid}
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(to, subject, body)
  end

  #-----------------------------------------
  # send mail activated
  #-----------------------------------------
  def self.send_activated(to, email)
    subject = "Email Address Confirmed!"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Welcome to Knack. Your email address has been confirmed.
    <br/><br/>
    You can login at any time by visiting:
    <br/><br/>
    <a href='https://knackregistry.com/partner/partnerslogin'>https://knackregistry.com/partner/partnerslogin</a>
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com
    <br/><br/>
    Thanks!<br/>
    The Knack Team"
    send(to, subject, body)
  end

  #-----------------------------------------
  # send gift notice
  #-----------------------------------------
  def self.send_gift_notice(registrant, r2p, contribute)
    quantity_string = ""
    quantity = MathUtilite.Round2(r2p.quantity_for_total(contribute.Contribute))

    if quantity.to_i == quantity
       quantity_string = "Quantity: #{quantity.to_i}"
    else
      quantity_string = "Amount Contributed: $#{("%.2f" % contribute.Contribute)}"
    end

    subject = "You have received a gift from your Knack registry"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Hi #{registrant.FirstName},
    <br/><br/>
    You have received a gift from your Knack registry.
    <br/><br/>
    Gift: <a href='https://knackregistry.com/browse/item/#{r2p.product.id}?r=#{registrant.id}&r2p=#{r2p.id}'> #{r2p.product.Name} </a>
    <br/>
    #{quantity_string}
    <br/>
    From: #{contribute.From}
    <br/>
    Note: #{contribute.Notes}
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(registrant.Email, subject, body)
  end

  #-----------------------------------------
  # send gift notice external
  #-----------------------------------------
  def self.send_ext_gift_notice(registrant, r2p, contribute)
    subject = "You have received a gift from your Knack registry"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Hi #{registrant.FirstName},
    <br/><br/>
    You have received a gift from your Knack registry.
    <br/><br/>
    Gift: <a href='https://knackregistry.com/browse/item/#{r2p.product.id}?r=#{registrant.id}&r2p=#{r2p.id}'> #{r2p.product.Name} </a>
    <br/>
    Quantity: #{r2p.quantity_for_contribution(contribute.Contribute).to_i}
    <br/>
    From: #{contribute.From}
    <br/>
    Note: #{contribute.Notes}
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(registrant.Email, subject, body)
  end

  #-----------------------------------------
  # send partner notice
  #-----------------------------------------
  def self.send_partner_notice(email, order_id)
    subject = "Knack Order notice"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    A customer has placed an order for you on Knack.
    <br/><br/>
    Please proceed to the orders section of the partner site and process order number #{order_id}.
    <br/><br/>
    If you are already logged in you can access the order directly <a href='https://knackregistry.com/partner/order/#{order_id}'>here</a>.
    <br/><br/>
    If you have any questions please contact us at support@knackregistry.com.
    Thanks!<br/>
    <br/><br/>
    The Knack Team"

    send(email, subject, body)
  end

  #-----------------------------------------
  # send partner payment notice
  #-----------------------------------------
  def self.send_partner_payment_notice(email, order_id)
    subject = "Knack Payment Notice"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    The Knack Team has sent a payment for you.
    <br/><br/>
    Please proceed to the orders section of the partner site to see the details of order #{order_id}.
    <br/><br/>
    If you are already logged in you can access the order directly <a href='https://knackregistry.com/partner/order/#{order_id}'>here</a>.
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(email, subject, body)
  end

  #-----------------------------------------
  # send registrant payment notice
  #-----------------------------------------
  def self.send_registrant_payment_notice(email, order_id)
    subject = "Knack Payment Notice"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Good News! The Knack Team has sent a payment for you.
    <br/><br/>
    If you chose to receive payment via check, you will receive the check at the address in your account profile within five business days.
    <br/><br/>
    If you chose to receive payment via paypal, please check your paypal account now.
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(email, subject, body)
  end

  #-----------------------------------------
  # send payment failed
  #-----------------------------------------
  def self.send_payment_failed(order)
    subject = "Knack Payment Failed"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Dear #{order.BillingFirstName} #{order.BillingLastName}
    <br/><br/>
    We're writing to inform you that we were unable to charge your Credit Card for the order
    listed below. The most likely reason is the Billing Information address provided during
    checkout does not match the billing address of your credit card. Please verify that
    the addresses match, and try again. Your credit card has not been charged
    <br/><br/>
    If you have any questions, comments or suggestions, feel free to contact us at support@knackregistry.com.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(order.BillingEmail, subject, body)
  end

  #-----------------------------------------
  # send reset password
  #-----------------------------------------
  def self.send_reset_password(registrant)
    subject = "Knack Reset Password"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    A request to reset your password has been made.
    <br/><br/>
    If you are attempting to reset your password please click the link below.
    <br/><br/>
    <a href='https://knackregistry.com/registrant/forgotpassword/#{registrant.ImageGUID}'>
      Reset Password
    </a>
    <br/><br/>
    If the link does not work, copy the following url into your browser's address bar'.
    <br/><br/>
    https://knackregistry.com/registrant/forgotpassword/#{registrant.ImageGUID}
    <br/><br/>
    If you did not request a password reset, or you have any questions, please contact us at support@knackregistry.com.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(registrant.Email, subject, body)
  end

  #-----------------------------------------
  # send reset partner password
  #-----------------------------------------
  def self.send_reset_partner_password(partner)
    subject = "Reset Password"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    A request to reset your password has been made.
    <br/><br/>
    If you are attempting to reset your password please click the link below.
    <br/><br/>
    <a href='https://knackregistry.com/partner/forgotpassword/#{partner.ImageGUID}'>
      Reset Password
    </a>
    <br/><br/>
    If the link does not work, copy the url below into your browser's address bar.
    <br/><br/>
    https://knackregistry.com/partner/forgotpassword/#{partner.ImageGUID}
    <br/><br/>
    If you did not request a password reset, or you have any questions, please contact us at support@knackregistry.com.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(partner.Email, subject, body)
  end

  #-----------------------------------------
  # send new password
  #-----------------------------------------
  def self.send_forgot_password(registrant, password)
    subject = "New Password"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Hi #{registrant.FirstName},
    <br/><br/>
    Your new password is: <b>#{password}</b>
    <br/><br/>
    You may use this password to log-in to Knack.
    <br/><br/>
    Then you can change the password by visiting the profile page.
    <br/><br/>
    If you run into any problems accessing your account please contact support@knackregistry.com and we'll be happy to help you sort it out.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"

    send(registrant.Email, subject, body)
  end

  #-----------------------------------------
  # send new partner password
  #-----------------------------------------
  def self.send_forgot_partner_password(partner, password)
    subject = "New Password"
    body = "
    <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
    <br/><br/>
    Hi #{partner.BillingName},
    <br/><br/>
    Your new password is: <b>#{password}</b>
    <br/><br/>
    You may use this password to log-in to Knack.
    <br/><br/>
    You can then change the password by visiting the profile page.
    <br/><br/>
    If you run into any problems accessing your account please contact support@knackregistry.com and we'll be happy to help you sort it out.
    <br/><br/>
    Thanks!<br/>
    The Knack Team"


    send(partner.Email, subject, body)
  end

  #-----------------------------------------
  # send order
  #-----------------------------------------
  def self.send_order(order)
    begin
      order = Order.find(order.id)
      subject = "Knack Order Confirmation"
      body = "
      <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
      <br/><br/>
      Hi #{order.BillingFirstName},
      <br/><br/>
      We're writing to confirm your purchase of the following from Knack:
      <br/><br/>
      #{get_text_products_name(order)}
      <br/><br/>
      Thanks for getting involved with Knack!  By purchasing through Knack you have supported a small business movement that is creating jobs and helping build stronger communities.
      <br/><br/>
      Keep in touch with us and spread the word by <a href='https://www.facebook.com/knackregistry'>becoming a fan of ours on Facebook</a>.
      <br/><br/>
      If you need anything at all, or have any feedback, please email us at support@knackregistry.com.
      <br/><br/>
      Thanks!<br/>
      The Knack Team"

      send(order.BillingEmail, subject, body)
    rescue => exception
      notify_airbrake(exception)
    end
  end

  #-----------------------------------------
  # send order_ext
  #-----------------------------------------
  def self.send_order_ext(order)
    begin
      order = Order.find(order.id)
      reg_item = order.registry_items.first
      cont = order.contributes.first
      subject = "Knack Order Confirmation"
      body = "
      <img src='https://knackregistry.com/images/design/logo.gif' alt='logo'>
      <br/><br/>
      Hi #{order.BillingFirstName},
      <br/><br/>
      We're writing to confirm your purchase of the following item from a registry on Knack:
      <br/><br/>
      Gift: <a href='https://knackregistry.com/browse/item/#{reg_item.product.id}?r=#{reg_item.registrant.id}&r2p=#{reg_item.id}'> #{reg_item.product.Name} </a>
      <br/>
      Quantity: #{reg_item.quantity_for_contribution(cont.Contribute).to_i}
      <br/>
      From: #{cont.From}
      <br/>
      Note: #{cont.Notes}
      <br/><br/>
      <br/><br/>
      This item is offered by #{order.registry_items.first.product.source_name}, and as part of the order process you should have placed an order on their site.
      <br/><br/>
      If you did not complete your order with the vendor, please <a href='#{order.registry_items.first.product.source_url}'>return to the item</a> and complete the order.
      <br/><br/>
      Gifts should be shipped to
      <br/><br/>
      #{reg_item.registrant.name_couple}
      <br/>
      #{reg_item.registrant.Address} <br/>
      #{reg_item.registrant.City}, #{reg_item.registrant.state.Name}, #{reg_item.registrant.ZIP}
      <br/><br/>
      If you decided not to purchase the item, or if you need to change something about the order, <a href='https://knackregistry.com/buy/edit_ext_order/#{order.id}'>click here</a>
      <br/><br/>
      <br/><br/>

      If you need anything at all, or have any feedback, please email us at support@knackregistry.com.
      <br/><br/>
      Thanks!<br/>
      The Knack Team"

      send(order.BillingEmail, subject, body)
    rescue Exception => e
      notify_airbrake(e)
    end
  end

  def self.get_text_products_name(order)
    names = ""
    order.get_products_name.each do |p|
        names += "<b>#{p}</b><br/>"
      end
    return names
  end

  def self.get_text_order(order)
    '
    Order Number:' + order.id.to_s + '
    Order Date: ' + order.DateTime.to_s + '
    Customer: ' + order.BillingFirstName.to_s + ' ' +  order.BillingLastName.to_s + '

    Shipping to:
    ' + order.ShippingFirstName.to_s + ' ' +  order.ShippingLastName.to_s + '
    ' + order.ShippingAddress.to_s + '
    ' + order.ShippingCity.to_s + ' ' + State.find(order.ShippingState_ID).Name + ' ' + order.ShippingZip.to_s + '


    ' + get_list_products(order) + '
    '
  end

  def self.get_list_products(order)
    products = 'Item    Quantity    Description
    '
    order.orders2products.each do |o2p|
        products += o2p.product.Name + '    ' + o2p.Quantity.to_s + '    ' + o2p.product.Description + '
    '
    end

    order.orders2registry_items.each do |o2p|
      products += o2p.registry_item.product.Name + '    ' + o2p.registry_item.Quantity.to_s + '    ' + o2p.registry_item.product.Description + '
    '
    end
    products
  end



  private
  def self.get_mail_option
    server = EmailServer.find(1)
    via_options = {
    :address              => server.address,
    :port                 => server.port,
    :enable_starttls_auto => true,
    :user_name            => server.user_name,
    :password             => server.password,
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => server.domain
    }
    return via_options
  end

  def self.get_from_mail
    server = EmailServer.find(1)
    return server.from
  end
end
