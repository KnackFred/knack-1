Then /^I should see "([^"]*)" rows? in the orders table$/ do |row_count|
  expected = row_count.to_i
  actual = page.all(".order").size
  raise("Exception! Expected #{expected} rows, but got #{actual}") unless expected == actual
end

Given /^I have "([^"]*)" orders?$/ do |count|
  @orders ||= []
  count.to_i.times do
    @orders << Factory.create(:order)
  end
end

Given /^I have orders? with the following statuses$/ do |table|
  table.hashes.each do |hash|
    case hash['order_status']
      when "New"
        Factory.create(:order, :OrdersStatus_ID => 1)
      when "Shipped"
        Factory.create(:order, :OrdersStatus_ID => 2)
      when "Canceled"
        Factory.create(:order, :OrdersStatus_ID => 3)
      when "Closed"
        Factory.create(:order, :OrdersStatus_ID => 4)
      else
        raise("Exception")
    end

  end
end

Given /^I have orders? with the following types/ do |table|
  table.hashes.each do |hash|
    case hash['order_type']
      when "Buy"
        Factory.create(:order, :order_type  => Order::BUY)
      when "Contribute"
        Factory.create(:order, :order_type  => Order::CONTRIBUTE)
      when "Withdraw Cash"
        Factory.create(:order, :order_type  => Order::WITHDRAW)
      else
        raise("Exception")
    end

  end
end

Then /^I should see the administrators edit page for the order/ do
  URI.parse(current_url).path.should == "/administrative/order/#{@orders[0].id}"
end


