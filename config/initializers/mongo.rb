# config/initializers/mongo.rb

Mongo::Logger.logger.level = ::Logger::FATAL # Set logger level to suppress MongoDB logs

# Access the MONGODB_URI environment variable
mongodb_uri = ENV['MONGODB_URI']

# Create a MongoDB client with the URI from the environment variable
MongoClient = Mongo::Client.new(mongodb_uri)