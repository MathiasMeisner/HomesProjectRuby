# config/initializers/import_homes_initializer.rb

# Load the HomeImportService file first
require_relative '../../app/services/home_import_service'

# Now use the HomeImportService class
uri = ENV['MONGODB_URI']
excel_file_path = 'C:\\code\\BoligsidenWebScrape\\BoligsidenWebScrape\\spiders\\output_excel_file.xlsx' # Adjust the file path as needed

# Ensure the method is called using the correct class name
imported_homes = HomeImportService.import_homes_from_excel(uri, excel_file_path)
