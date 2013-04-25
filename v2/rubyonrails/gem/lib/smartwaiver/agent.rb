require 'mechanize'

module Smartwaiver

  class Agent

    def initialize(api_key, api_version , rest_limit , base_url )
      
      raise ArgumentError, "Missing API Key: Add Smartwaiver.api_key = 'your-key-here' to an initializer" if api_key.blank?
      @api_key = api_key
      
      @api_version = api_version || "v2"
      @base_url = base_url || "https://www.smartwaiver.com/api/"
      @rest_limit = rest_limit.to_s || "10"
      
    end
    
    def request( extra_url = "" )
      final_url = @base_url + @api_version + "/?rest_request=" + @api_key + "&rest_limit=" + @rest_limit + extra_url 
      agent = Mechanize.new
      xml = agent.get(final_url).body
      response = Hash.from_xml xml
      
      # If there is only a single element in the xml node, Hash.from_xml returns a Hash instead of an Array
      # This section wraps the Hash inside an Array for consistency.
      unless response["xml"].blank? or response["xml"]["participants"].blank?
        if response["xml"]["participants"]["participant"].is_a?(Hash)
          response["xml"]["participants"]["participant"] = [ response["xml"]["participants"]["participant"] ]
        end
      end
      
      unless response["xml"].blank? or response["xml"]["waivers"].blank?
        if response["xml"]["waivers"]["waiver"].is_a?(Hash)
          response["xml"]["waivers"]["waiver"] = [ response["xml"]["waivers"]["waiver"] ]
        end
      end      
      
      return response["xml"]      
    end
    
    def download_pdf( pdf_url = "" )
      download_url = @base_url + "?rest_request=" + @api_key + "&restapi_viewpdf=" + pdf_url.to_s
      agent = Mechanize.new
      return agent.get(download_url).body      
    end
    
    
  end
  
end
