# user.rb

require 'bcrypt'

class User
  attr_accessor :id, :email, :password

  def initialize(attributes = {})
    @id = attributes[:id]
    @email = attributes[:email]
    @password = attributes[:password]
  end

  def save
    unless User.find_by_email(email)
      self.class.users_collection.insert_one(email: email, password_digest: encrypted_password)
      return true
    end
    false
  end

  def self.find_by_email(email)
    users_collection.find(email: email).first
  end

  def self.authenticate(email, password)
    user_data = find_by_email(email)
    puts "User data retrieved from database: #{user_data.inspect}"
    if user_data && BCrypt::Password.new(user_data['password_digest']) == password
      puts "Password comparison successful"
      user = new(id: user_data['_id'], email: user_data['email'], password: user_data['password'])
      user
    else
      puts "Password comparison failed"
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

  private

  def encrypted_password
    BCrypt::Password.create(password)
  end
end