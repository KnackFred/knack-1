
And /^I have a partner that is "([^"]*)" and "([^"]*)"$/ do |deleted, activated|
  @category = Factory.create(:category)
  @state = State.find_by_Name("Washington")

  case deleted
    when "available"
      is_deleted = false
    when "not available"
      is_deleted = true
    else
      raise("Exception")
  end

  case activated
    when "activated"
      is_activated = true
    when "not activated"
      is_activated = false
    else
      raise("Exception")
  end

  @partner = Factory.create(:partner, :IsActivated => is_activated, :IsDeleted => is_deleted)

end

Then /^I should see an "([^"]*)" "([^"]*)" partner$/ do |is_deleted, isActivated|
  page.should have_selector(".partner", :content => "fail")
end

