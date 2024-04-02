class Api::HomesController < ApplicationController
  def index
    collection = MongoClient[:homes]
    @homes = collection.find.map { |doc| Home.new(doc) }

    respond_to do |format|
      format.json { render json: @homes }
      format.html { render template: 'pages/homes' }
    end
  end

  def filter_homes
    begin
      collection = MongoClient[:homes]

      min_price = params[:min_price].to_i
      max_price = params[:max_price].to_i
    
      # Construct the MongoDB query document
      query = {}
    
      # Add the condition for min_price if it's provided
      query[:price] = { '$gte': min_price } if min_price.positive?
    
      # Add the condition for max_price if it's provided
      query[:price] ||= {} # Ensure :price key exists
      query[:price]['$lte'] = max_price if max_price.positive?
    
      # Perform the query
      @homes = collection.find(query).map { |doc| Home.new(doc) }

      respond_to do |format|
        format.json { render json: @homes }
        format.html { render template: 'pages/homes' }
      end
    rescue => e
      logger.error "Error filtering homes: #{e.message}"
      []
    end
  end 
end
