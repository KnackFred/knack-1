When /^I hit ok in the buy-contribute dialog$/ do
  found = false
  sleep 10
  if page.has_selector?("#ifr-popup")
    within_frame "ifr-popup" do
      if page.has_selector?("#buy_registry_item_submit")
        find("#buy_registry_item_submit").click
        found = true
      elsif page.has_selector?(".btn-proceed")
        find(".btn-proceed").click
        found = true
      end
    end
  end
  if page.has_selector?("#ifr-popupBuy")
    within_frame "ifr-popupBuy" do
      if page.has_selector?(".btn-proceed")
        find(".btn-proceed").click
        found = true
      end
    end
  end
  throw "Can not find button" unless found

  wait_until do
    page.evaluate_script('$.active') == 0
  end
  sleep 1
end

When /^I fill out the gift info$/ do
  within_frame "ifr-popup" do
    fill_in "buy_registry_item_from", :with => "test name"
    fill_in "buy_registry_item_notes", :with => "test note"
  end
end