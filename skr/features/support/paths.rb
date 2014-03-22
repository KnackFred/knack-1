module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'

    when /^the profile\s?page$/
      '/profile'

    when /^the Forgot Password page/
      '/registrant/forgotpassword'

    when /^the Confirm Sign Up page/
          '/registrant/confirm'

    when /^the links page/
          '/links'

    when /^the Add Gifts? page/
          '/addgift'

    when /^the [aA]dd my own [gG]ifts? page/
          '/registrant/addmyowngift'

    when /^the Registry page/
          '/registry'

    when /^the Manage Registry page/
          '/manage_registry'

      when /^the All Transactions page/
          '/transactions'

    when /^the orders page/
          '/partner/orders'

    when /^the browse page/
          '/catalog'

    when /^the products page/
          '/partner/productlist'

    when /^the brand's page/
      "/brand/#{@brands[0].id}"

#    when /^the item page for (.*) product and (.*) category/
#      from_catalog_path($1,$2)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))


    when /Cart/
      '/cart'

    when /^the\sadministrator\s?profile\spage$/
      '/administrative/profile'

    when /^the\sadministrator\s?products\spage/
      '/admin/products'

    when /^the\sadministrator\s?editproduct\spage/
      '/admin/products/editproduct'

    when /^the\sadministrator\s?orders\spage/
      '/administrative/orders'

    when /^the\sadministrator\s?order\spage for order (.*)/
      "/administrative/order/#{$1}"

    when /^the\sadministrator\s?categories\spage/
      '/administrative/categorylist'

    when /^the\sadministrator\s?categories\spage for category (.*)/
      "/administrative/editcategory/#{$1}"

    when /^the\sadministrator\s?partners\spage/
      '/administrative/partners'

    when /^the\sadministrator\s?edit\spage for product (.*)/
      "/administrative/editproduct/#{$1}"

    when /^the\spartner\s?sign-?up\spage$/
      '/partner/partnerregister'

    when /^the\spartner\s?sign-?in\spage$/
      '/partner/partnerslogin'

    when /^the\spartner\s?profile\spage$/
      '/partner/partnerprofile'

    when /^the\spartner\s?confirm\spage$/
      '/partner/partnerconfirm'

    when /^the\spartner\s?sign-?in\spage$/
      '/partner/partnerslogin'

    when /^the\spartner\s?profile\spage$/
      '/partner/partnerprofile'

    when /^the\spartner\s?administrators\spage$/
      '/partner/administrators'

    when /^the\spartner\s?administrator\spage$/
      '/partner/administrator'

    when /^the\sstores\s?list\spage$/
      '/partner/storeslist'

    when /^the\sedit\s?store\spage$/
      '/partner/editstore'

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
