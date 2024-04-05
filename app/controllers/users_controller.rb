# users_controller.rb

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.id = generate_unique_id # Assign a unique ID
    if @user.save
      session[:user_id] = @user.id # Log in the user by setting the session
      puts "Session user_id: #{session[:user_id]}" # Debug statement
      redirect_to api_homes_path, notice: "Registration successful! You are now logged in."
    else
      flash.now[:alert] = "Email is already in use. Please choose a different email."
      render "new"
    end
  end
  
  def show
    render json: User.find_by(id: session[:user_id])
  end
  
  private

  def generate_unique_id
    loop do
      unique_id = SecureRandom.uuid
      return unique_id unless User.find(unique_id)
    end
  end  

  def user_params
    params.permit(:email, :password, :authenticity_token, :commit)
  end
end