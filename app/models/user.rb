# user.rb

require 'bcrypt'

class User
  attr_accessor :id, :email, :password, :favorite_home_ids

  def initialize(attributes = {})
    @id = attributes[:id]
    @email = attributes[:email]
    @password = attributes[:password]
    @favorite_home_ids = attributes[:favorite_home_ids] || [] # Initialize with empty array if not provided
  end

  def save
    unless User.find_by_email(email)
      self.class.users_collection.insert_one(email: email, password_digest: encrypted_password, favorite_home_ids: favorite_home_ids)
      return true
    end
    false
  end

  def self.find_by_email(email)
    users_collection.find(email: email).first
  end

  def self.authenticate(email, password)
    user_data = find_by_email(email)
    if user_data && BCrypt::Password.new(user_data['password_digest']) == password
      new(id: user_data['_id'], email: user_data['email'], password: user_data['password'], favorite_home_ids: user_data['favorite_home_ids'])
    else
      nil
    end
  end

  def self.find(id)
    user_data = users_collection.find(_id: id).first
    new(user_data) if user_data
  end

  def self.users_collection
    MongoClient[:users]
  end

  def add_favorite_home(home_id)
    favorite_home_ids << home_id
    update_favorite_home_ids
  end

  def remove_favorite_home(home_id)
    favorite_home_ids.delete(home_id)
    update_favorite_home_ids
  end

  private

  def update_favorite_home_ids
    self.class.users_collection.find(_id: id).update_one('$set' => { favorite_home_ids: favorite_home_ids })
  end

  def encrypted_password
    BCrypt::Password.create(password)
  end
end
