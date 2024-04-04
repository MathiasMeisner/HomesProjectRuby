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
      min_sqm = params[:min_sqm].to_i
      max_sqm = params[:max_sqm].to_i
      min_constructionyear = params[:min_constructionyear].to_i
      max_constructionyear = params[:max_constructionyear].to_i
  
      # Construct the MongoDB query document
      query = {}
  
      # Add the conditions for properties
      if min_price.positive? || max_price.positive?
        query[:price] = {}
        query[:price]['$gte'] = min_price if min_price.positive?
        query[:price]['$lte'] = max_price if max_price.positive?
      end
  
      if min_sqm.positive? || max_sqm.positive?
        query[:squaremeters] = {}
        query[:squaremeters]['$gte'] = min_sqm if min_sqm.positive?
        query[:squaremeters]['$lte'] = max_sqm if max_sqm.positive?
      end

      if min_constructionyear.positive? || max_constructionyear.positive?
        query[:constructionyear] = {}
        query[:constructionyear]['$gte'] = min_constructionyear if min_constructionyear.positive?
        query[:constructionyear]['$lte'] = max_constructionyear if max_constructionyear.positive?
      end
  
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
