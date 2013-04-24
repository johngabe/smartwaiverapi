class ApisController < ApplicationController
  
  # This is a sample controller with one method only, to demonstrate logging of a new waiver. 
  # You will need to include the 'smartwaiver' gem, a smartwaiver.rb initializer file, and create a view file before using
  # this controller.
  
  # Disable CSRF checking since the Smartwaiver site will POST to this URL
  protect_from_forgery :except => [:webhook, :test]
  
  def webhook
    
    # make sure all required values are passed
    if params[:unique_id].blank?
      raise ArgumentError, "The :unique_id parameter must be posted to this URL"
    elsif params[:credential].blank?
      raise ArgumentError, "The :credential parameter must be posted to this URL"
    elsif params[:event].blank?
     raise ArgumentError, "The :event parameter must be posted to this URL"
    end
    
    # for now you only want to support new-waiver events.  This was added so that we can add future web hooks without conflict.
    if !params[:event].eql?('new-waiver')
      raise ArgumentError, "Only new-waiver events are currently supported."
    end

    # Check that the credential is correct
    if !params[:credential].eql?( Smartwaiver.hashed_credential( params[:unique_id]) )
      raise ArgumentError, "Your credentials do not match."
    end

    @api_result = Smartwaiver.get_waiver( params[:unique_id] )
  
    @output = "";
 
    if @api_result["participants"].blank?
      @output = "No Waivers found." # if you don't have any waivers it'll fail here
      
    else
      
      @api_result["participants"]["participant"].each do |participant|
        # the next 3 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
        
        waiver_id = participant["waiver_id"]
        firstname = participant['firstname']
        lastname = participant['lastname']
        
        # INSERT INTO DATABASE HERE
        logger.warn "Waiver ID: #{waiver_id}"
        logger.warn "Firstname: #{firstname}"
        logger.warn "Lastname: #{lastname}"        
        
      end
    end
    render :examples, :layout => false 
  end

end
