class UpsController < ApplicationController
  require 'active_shipping'
  include ActiveMerchant::Shipping
  def getcost

    # Package up a poster and a Wii for your nephew.
    packages = [
      Package.new(  100,                        # 100 grams
                    [93,10],                    # 93 cm long, 10 cm diameter
                    :cylinder => true),         # cylinders have different volume calculations

      Package.new(  (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
                    [15, 10, 4.5],              # 15x10x4.5 inches
                    :units => :imperial)        # not grams, not centimetres
    ]

    # You live in Beverly Hills, he lives in Ottawa
    origin = Location.new(      :country => 'US',
                                :state => 'CA',
                                :city => 'Beverly Hills',
                                :zip => '90210')

    destination = Location.new( :country => 'CA',
                                :province => 'ON',
                                :city => 'Ottawa',
                                :postal_code => 'K1P 1J1')

    # Find out how much it'll be.
    ups = UPS.new(:login => 'auntjudy', :password => 'secret', :key => 'xml-access-key', :test => 'true')
    response = ups.find_rates(origin, destination, packages)

    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # => [["UPS Standard", 3936],
    #     ["UPS Worldwide Expedited", 8682],
    #     ["UPS Saver", 9348],
    #     ["UPS Express", 9702],
    #     ["UPS Worldwide Express Plus", 14502]]

    # Check out USPS for comparison...
    usps = USPS.new(:login => 'developer-key')
    response = usps.find_rates(origin, destination, packages)

    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # => [["USPS Priority Mail International", 4110],
    #     ["USPS Express Mail International (EMS)", 5750],
    #     ["USPS Global Express Guaranteed Non-Document Non-Rectangular", 9400],
    #     ["USPS GXG Envelopes", 9400],
    #     ["USPS Global Express Guaranteed Non-Document Rectangular", 9400],
    #     ["USPS Global Express Guaranteed", 9400]]

    # FedEx
    fdx = FedEx.new(:login => 'Your 9-digit FedEx Account #', :password => 'Your Meter Number')
    response = fdx.find_rates(origin, destination, packages, :test => true)
    response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # => [["FedEx Ground", 977],
    # ["FedEx Ground Home Delivery", 1388],
    # ["FedEx Express Saver", 2477],
    # ["FedEx 2 Day", 2718],
    # ["FedEx Standard Overnight", 4978],
    # ["FedEx Priority Overnight", 8636],
    # ["FedEx First Overnight", 12306]]

    # FedEx Tracking
    fdx = FedEx.new(:login => '999999999', :password => '7777777')
    tracking_info = fdx.find_tracking_info('tracking number here', :carrier_code => 'fedex_ground') # Ground package

    tracking_info.shipment_events.each do |event|
      puts "#{event.name} at #{event.location.city}, #{event.location.state} on #{event.time}. #{event.message}"
    end
    # => Package information transmitted to FedEx at NASHVILLE LOCAL, TN on Thu Oct 23 00:00:00 UTC 2008.
    # Picked up by FedEx at NASHVILLE LOCAL, TN on Thu Oct 23 17:30:00 UTC 2008.
    # Scanned at FedEx sort facility at NASHVILLE, TN on Thu Oct 23 18:50:00 UTC 2008.
    # Departed FedEx sort facility at NASHVILLE, TN on Thu Oct 23 22:33:00 UTC 2008.
    # Arrived at FedEx sort facility at KNOXVILLE, TN on Fri Oct 24 02:45:00 UTC 2008.
    # Scanned at FedEx sort facility at KNOXVILLE, TN on Fri Oct 24 05:56:00 UTC 2008.
    # Delivered at Knoxville, TN on Fri Oct 24 16:45:00 UTC 2008. Signed for by: T.BAKER

    tracking_info = fdx.find_tracking_info('tracking number here', :carrier_code => 'fedex_express') # Express package

    tracking_info.shipment_events.each do |event|
      puts "#{event.name} at #{event.location.city}, #{event.location.state} on #{event.time}. #{event.message}"
    end
    # => Picked up by FedEx at NASHVILLE, TN on Wed Dec 03 16:46:00 UTC 2008.
    # Package status at MISSISSAUGA, ON on Wed Dec 03 18:00:00 UTC 2008.
    # Left FedEx Origin Location at NASHVILLE, TN on Wed Dec 03 20:27:00 UTC 2008.
    # Arrived at FedEx Ramp at NASHVILLE, TN on Wed Dec 03 20:43:00 UTC 2008.
    # Left FedEx Ramp at NASHVILLE, TN on Wed Dec 03 22:30:00 UTC 2008.
    # Arrived at Sort Facility at INDIANAPOLIS, IN on Thu Dec 04 00:31:00 UTC 2008.
    # Left FedEx Sort Facility at INDIANAPOLIS, IN on Thu Dec 04 01:14:00 UTC 2008.
    # Left FedEx Sort Facility at INDIANAPOLIS, IN on Thu Dec 04 04:48:00 UTC 2008.
    # Arrived at FedEx Ramp at MISSISSAUGA, ON on Thu Dec 04 06:26:00 UTC 2008.
    # Package status at MISSISSAUGA, ON on Thu Dec 04 07:03:00 UTC 2008.
    # Left FedEx Ramp at MISSISSAUGA, ON on Thu Dec 04 07:37:00 UTC 2008.
    # Arrived at FedEx Destination Location at TORONTO, ON on Thu Dec 04 08:42:00 UTC 2008.
    # On FedEx vehicle for delivery at TORONTO, ON on Thu Dec 04 09:04:00 UTC 2008.
    # Delivered to Non-FedEx clearance broker at TORONTO, ON on Thu Dec 04 10:15:00 UTC 2008.

#    ups = Shipping::UPS.new :zip => 97202, :state => "OR", :sender_zip => 10001, :weight => 2
#    #ups.valid_address? => false
#
#    ups.city = "Portland"
#    if ups.valid_address?
#      a = 1
#    end
#    access_options = {
#    :url => 'https://wwwcie.ups.com/ups.app/xml/TimeInTransit',
#    :access_license_number => '123544775',
#    :user_id => 'test',
#    :password => 'test',
#    :order_cutoff_time => 17 ,
#    :sender_city => 'Hoboken',
#    :sender_state => 'NJ',
#    :sender_country_code => 'US',
#    :sender_zip => '07030'}
#
#    #yaml = YAML.load_file("#{RAILS_ROOT}/config/ups_time_in_transit.yml")
#    #access_options = yaml[RAILS_ENV].inject({}){|h,(k, v)| h[k.to_sym] = v; h}
#
#    time_in_transit_api = UPS::TimeInTransit.new(access_options)
#
#    # for each request, generate a map of request options describing
#    # the shipment and where it's going
#    request_options = {
#      :total_packages => 1,
#      :unit_of_measurement => 'LBS',
#      :weight => 10,
#      :city => 'Newark',
#      :state => 'DE',
#      :zip => '19711',
#      :country_code => 'US'}
#
#    # request the map of delivery types (overnight, ground, etc.) to the expected
#    # delivery date for that type.  Be sure to rescue any errors.
#    begin
#      delivery_dates = time_in_transit_api.request(request_options)
#    rescue => error
#      puts error.inspect
#    end
  end
end
