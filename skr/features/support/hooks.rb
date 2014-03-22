Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
  DatabaseCleaner.strategy = :truncation, {:except => %w[states registrant_types product_statuses shippingmethods commissions colors]}
end