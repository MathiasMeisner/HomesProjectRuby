require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "should route to api/homes#index" do
    assert_routing({ method: 'get', path: '/api/homes' }, { controller: "api/homes", action: "index" })
  end
end
