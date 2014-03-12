class ApisController < ApplicationController
   def check_ins
     checkin_limit = 10
     @api_result = Smartwaiver.get_checkins( checkin_limit )
     if @api_result["checkins"].blank? or @api_result["checkins"]["checkin"].blank?
       @output = "No Waivers found." # if you don't have any waivers it'll fail here

     else
       @output = ""

       # DOWNLOAD EACH WAIVER (You can bulk download up to 100 waivers at a time by modifying &rest_limit above to the desired # of participants)
       @api_result["checkins"]["checkin"].each do |check|
         @output << "Participant ID:" + check["participant_id"] + "<br/> Date UTC:" + check["date_utc"] + "<hr>"
       end

     end
   end
end