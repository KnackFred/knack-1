When /^I click first stock image in frame "([^"]*)"$/ do |selector|
  within_frame selector do
    find(:xpath, '//img[@class="stock_image"]').click
  end
end