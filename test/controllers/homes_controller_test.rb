require 'test_helper'

class HomesControllerTest < ActionDispatch::IntegrationTest

    test "should return a not empty array" do
        get '/api/homes'
        assert_response :success
        assert_not_empty response.body
    end
    
    test "should return list of filtered homes - price" do
        get '/api/homes/filter_homes?min_price=3000000&max_price=&min_sqm=&max_sqm=&min_constructionyear=&max_constructionyear='
        assert_response :success
        assert_not_empty response.body
    end

    test "should return list of filtered homes - sqm" do
        get '/api/homes/filter_homes?min_price=&max_price=&min_sqm=150&max_sqm=&min_constructionyear=&max_constructionyear='
        assert_response :success
        assert_not_empty response.body
    end

    test "should return list of filtered homes - construction year" do
        get '/api/homes/filter_homes?min_price=&max_price=&min_sqm=&max_sqm=&min_constructionyear=2000&max_constructionyear='
        assert_response :success
        assert_not_empty response.body
    end
end
