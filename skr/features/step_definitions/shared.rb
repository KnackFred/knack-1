Then /^Show Page$/ do
  save_and_open_page
end


Then /^custom step with "([^"]*)"$/ do |arg1|
  wait_until 10 do
    within_frame "ifr-popup" do  |context|
      context.should have_content(arg1)
    end
  end
end

Given /^a clean slate$/ do
  [Product, Category, Store, Partner].each do |model|
    model.delete_all
  end
end

Given /^the (\w+) indexes are processed$/ do |model|
  model = model.titleize.gsub(/\s/, '').constantize
  ThinkingSphinx::Test.index *model.sphinx_index_names
  sleep 0.1
end


Then /^(?:|I )should see in this order(?: within "([^\"]*)")?: (.*)$/ do |selector, text|
  order = Regexp.new(text.gsub(', ', '.*'), Regexp::MULTILINE)

  with_scope(selector) do
    raise "Did not find keywords in the requested order!" unless page.body =~ order
  end
end

Then /^I should see read only field "([^"]*)"$/ do |field|
  find_field(field)["readonly"].should_not be_nil
end

Then /^I should see a validation error in the pop\-up$/ do
  within_frame "ifr-popup" do
    page.should have_selector('.error')
  end
end

Then /^I should see a validation error$/ do
  page.should have_css(".field_with_errors")
end