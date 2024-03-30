# app/models/home.rb

class Home
    include ActiveModel::Model
    
    attr_accessor :_id, :address, :municipality, :price, :squaremeters, :constructionyear, :energylabel, :imageurl
    
  end
  