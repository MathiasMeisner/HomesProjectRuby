# app/controllers/api/homes_controller.rb

class Api::HomesController < ApplicationController
    def index
      collection = MongoClient[:homes]
      @homes = collection.find.map { |doc| Home.new(doc) }
      render json: @homes
    end
  end

  