class ApisController < ApplicationController
  
  # This is a sample controller with one method only, to demonstrate retrieving a list of waivers. 
  # You will need to include the 'smartwaiver' gem, a smartwaiver.rb initializer file, and create a view file before using
  # this controller.
    
  def examples
    
    @api_result = Smartwaiver.get_waivers(10)
    @output = "";
 
    if @api_result["participants"].blank?
      @output = "No Waivers found." # if you don't have any waivers it'll fail here
      
    else
      
      @api_result["participants"]["participant"].each do |participant|
        
        # the next 2 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
        @output << "#{participant['waiver_id']}: #{participant['firstname']} #{participant['lastname']} <br />"
      end
    end
    render :layout => false
    
  end

end
