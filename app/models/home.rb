# app/models/home.rb

class Home
  include ActiveModel::Model

  attr_accessor :_id, :address, :municipality, :price, :squaremeters, :constructionyear, :energylabel, :imageurl

  validates_presence_of :address, :municipality, :price

  def self.find(id)
    home_data = MongoClient[:homes].find(_id: BSON::ObjectId(id)).first
    new(home_data) if home_data
  end
end

