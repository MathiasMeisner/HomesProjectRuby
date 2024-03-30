require 'mongo'
require 'rubyXL'

class HomeImportService
    def self.import_homes_from_excel(uri, excel_file_path)
        client = Mongo::Client.new(uri)
        imported_homes = []
    
        begin
          workbook = RubyXL::Parser.parse(excel_file_path)
    
          worksheet = workbook[0] # Assuming the data is in the first sheet
    
          (1..worksheet.count - 1).each do |row_index|
            row = worksheet[row_index]
    
            home = {
              municipality: row[1].value,
              address: row[0].value,
              price: row[2].value,
              squaremeters: row[3].value,
              constructionyear: row[4].value,
              energylabel: row[5].value,
              imageurl: row[6].value
            }
    
            insert_home(client, home)
            imported_homes.push(home)
          end
        rescue StandardError => e
          puts "Error: #{e.message}"
        ensure
          client.close
        end
    
        imported_homes
      end

      def self.insert_home(client, home)
        begin
          homes_collection = client[:homes]
      
          existing_home = homes_collection.find(address: home[:address]).first
      
          if existing_home
            if home[:imageurl]
              update_result = homes_collection.update_one(
                { address: home[:address] },
                { '$set' => { imageurl: home[:imageurl] } }
              )
      
              unless update_result.modified_count > 0
                puts "Failed to update existing home: #{home[:address]}"
              end
            else
              puts "New home has no image URL, skipping update: #{home[:address]}"
            end
          else
            insert_result = homes_collection.insert_one(home)
      
            # Use the acknowledged? method to check if the insert was successful
            if insert_result.acknowledged?
              puts "New home inserted into the database: #{home[:address]}"
            else
              puts "Failed to insert new home into the database: #{home[:address]}"
            end
          end
      
          # Check if the existing home is not present in the new data and delete it
          if existing_home && !home[:imageurl]
            delete_result = homes_collection.delete_one({ address: home[:address] })
            if delete_result.deleted_count > 0
              puts "Deleted home from the database: #{home[:address]}"
            else
              puts "Failed to delete home from the database: #{home[:address]}"
            end
          end
        rescue StandardError => e
          puts "Error inserting/updating/deleting home into/from the database: #{e.message}"
        end
      end
end
