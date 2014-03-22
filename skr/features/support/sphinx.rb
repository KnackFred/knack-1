require 'cucumber/thinking_sphinx/external_world'

Cucumber::Rails::World.use_transactional_fixtures = false
Cucumber::ThinkingSphinx::ExternalWorld.new
DatabaseCleaner.strategy = :truncation, {:except => %w[states registrant_types product_statuses shippingmethods commissions colors]}
Before('@no-txn') do
  #Given 'a clean slate'
end

After('@no-txn') do
#  Given 'a clean slate'
end