# sessions_controller.rb

class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.json { render json: @homes }
      format.html { render template: 'sessions/login' }
    end
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    puts "User object returned by User.authenticate: #{user.inspect}"
    if user
      puts "Session before setting user_id: #{session.inspect}"
      session[:user_id] = user.id
      puts "Session after setting user_id: #{session.inspect}"
      redirect_to api_homes_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Invalid email or password"
      render "login"
    end
  end

  def show
    render json: User.find_by(id: session[:user_id])
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end