require 'test_helper'

class HomesControllerTest < ActionDispatch::IntegrationTest

    test "should return a not empty array" do
        get '/api/homes'
        assert_response :success
        assert_not_empty response.body
        assert_instance_of Array, JSON.parse(response.body)
    end
    
end
