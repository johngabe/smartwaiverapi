class ApisController < ApplicationController
  
  # This is a sample controller with one method only, to demonstrate retrieving a list of waiver types. 
  # You will need to include the 'smartwaiver' gem, a smartwaiver.rb initializer file, and create a view file before using
  # this controller.
  
  def waivertypes
    
    @api_result = Smartwaiver.get_waivertypes
    
    @output = ""
    
    @api_result["waivers"]['waiver'].each do |waiver|
      
      # Print the title of your waiver
      @output << "#{waiver['title']}: "
      
      # Determine the waiver's unique identifier
      guid = waiver["guid"]
      
      # Print links to both the web version & the kiosk version
      @output << "<a href = 'https://www.smartwaiver.com/w/#{guid}/web/'>web</a> | <a href = 'https://www.smartwaiver.com/w/#{guid}/kiosk'>kiosk</a><br>"
      
    end
    
    @output << "You have #{ @api_result['waivers'].length } waiver types."

    render :examples, :layout => false
  end


end
