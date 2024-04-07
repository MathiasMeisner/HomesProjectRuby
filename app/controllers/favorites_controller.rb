class FavoritesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :destroy]

    def create
        favorite_params = { user_id: params[:user_id], home_id: params[:home_id] }
        if save_favorite(favorite_params)
          render json: { message: 'Favorite created successfully' }, status: :created
        else
          render json: { error: 'Failed to create favorite' }, status: :unprocessable_entity
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

    def save_favorite(favorite)
        begin
          result = MongoClient[:favorites].insert_one({ user_id: favorite[:user_id], home_id: favorite[:home_id] })
          return result.inserted_id.present?
        rescue => e
          Rails.logger.error "Error saving favorite: #{e.message}"
          return false
        end
      end
      
  end
  