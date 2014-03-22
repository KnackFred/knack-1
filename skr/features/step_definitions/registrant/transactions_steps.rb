Then /^I should see an? "(.*?)" transaction with amount "(.*?)"$/ do |type, amount|
  within(".tbl-all tbody tr") do
    page.should have_content(type)
    page.should have_content(amount)
  end
end
