class FavoritesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :destroy]

    def create
      user_id = params[:user_id]
      home_id = params[:home_id]
    
      if save_favorite(user_id, home_id)
        render json: { message: 'Favorite created successfully' }, status: :created
      else
        render json: { message: 'Home already added to favorites' }, status: :ok
      end
    end
    
      
      def index
        user_id = params[:user_id]
    
        begin
          result = MongoClient[:favorites].find(user_id: user_id).to_a
          @favorites = result.map { |favorite| Home.find(favorite[:home_id]) }
        rescue Mongo::Error::NoServerAvailable => e
          Rails.logger.error "Error retrieving favorites: #{e.message}"
          @favorites = []
        end
    
        respond_to do |format|
          format.json { render json: @favorites }
          format.html { render template: 'pages/favorites' }
        end
      end

      def destroy
        user_id = params[:user_id]
        home_id = params[:home_id]
      
        begin
          result = MongoClient[:favorites].delete_one({ user_id: user_id, home_id: home_id })
          if result.deleted_count > 0
            render json: { message: 'Favorite deleted successfully' }, status: :ok
          else
            render json: { error: 'Failed to delete favorite' }, status: :unprocessable_entity
          end
        rescue => e
          Rails.logger.error "Error deleting favorite: #{e.message}"
          render json: { error: 'Failed to delete favorite' }, status: :unprocessable_entity
        end
      end      

    private

    def favorite_exists?(user_id, home_id)
      # Check if a favorite with the specified user_id and home_id exists
      MongoClient[:favorites].find(user_id: user_id, home_id: home_id).count > 0
    end
      
    
    def save_favorite(user_id, home_id)
      begin
        if favorite_exists?(user_id, home_id)
          puts "Favorite already exists for user #{user_id} and home #{home_id}"
          return false
        else
          result = MongoClient[:favorites].insert_one({ user_id: user_id, home_id: home_id })
          if result.inserted_id.present?
            puts "Favorite created for user #{user_id} and home #{home_id}"
            return true
          else
            puts "Failed to create favorite for user #{user_id} and home #{home_id}"
            return false
          end
        end
      rescue => e
        Rails.logger.error "Error saving favorite: #{e.message}"
        puts "Error saving favorite: #{e.message}"
        return false
      end
    end
    
    
  end
  