class ApisController < ApplicationController
  
  # This is a sample controller with one method only, to demonstrate downloading waiver PDF files. 
  # You will need to include the 'smartwaiver' gem, a smartwaiver.rb initializer file, and create a view file before using
  # this controller.

  def downloadpdf
    # SET A WRITABLE DIRECTORY WHERE YOU WANT TO SAVE YOUR PDF
    # IMPORTANT: Waivers should not be stored in directories that the public can access (or bots)!  Obviously waivers include private information and therefore should be in private directories.
    writable_dir = "#{Rails.root}/public/smartwaiver";   
    
    # REQUEST THE MOST RECENT WAIVER
    rest_limit = 1
    @api_result = Smartwaiver.get_waivers( rest_limit )
    
    if @api_result["participants"].blank?
      @output = "No Waivers found." # if you don't have any waivers it'll fail here
      
    else
      
      @output = ""
      
      # DOWNLOAD EACH WAIVER (You can bulk download up to 100 waivers at a time by modifying &rest_limit above to the desired # of participants)
      @api_result["participants"]["participant"].each do |participant|
        
        pdf_src = Smartwaiver.download_pdf( participant['pdf_url'] )
        
        unless pdf_src.blank?

          # if the next part fails you may not have write permission on the writable_dir
          File.open(File.join(writable_dir, "#{participant['waiver_id']}.pdf"), 'wb') do |f|
            f.puts pdf_src
          end          
          
          # TIP: saving the file as waiver_id.pdf is just an example but this will guarantee that all file names are unique.  
          # Feel free to save your files as anything that's convenient (i.e. your internal customer id).
          @output << "saved " + participant['firstname'] + ' ' + participant['lastname'] + "'s waiver with filename: " + participant['waiver_id'] + ".pdf<br>"
        end
        
      end
    end    

    render :examples, :layout => false 
  end

end
