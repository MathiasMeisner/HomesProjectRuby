# app/controllers/api/homes_controller.rb

class Api::HomesController < ApplicationController
  def index
    collection = MongoClient[:homes]
    @homes = collection.find.map { |doc| Home.new(doc) }

    respond_to do |format|
      format.json { render json: @homes }
      format.html { render template: 'pages/homes' }
    end
  end
end
