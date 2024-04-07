# app/models/favorite.rb
class Favorite
    include ActiveModel::Model
  
    attr_accessor :user_id, :home_id
  
    # Define any validations or additional logic here
  end
  