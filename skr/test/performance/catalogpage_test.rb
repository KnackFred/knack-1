require 'test_helper.rb'
require 'rails/performance_test_help'

class CatalogpageTest < ActionDispatch::PerformanceTest
  # Replace this with your real tests.
  def test_catalogpage
    get '/catalog'
  end
end
