require 'smartwaiver/agent'

module Smartwaiver
  
  mattr_accessor :api_key
  mattr_accessor :api_version
  mattr_accessor :base_url
  mattr_accessor :webhook_private_key


  # Retrieves waivers from the Smartwaiver API.
  #
  # @param [String] rest_limit Number of records to retrieve, eg "10"
  def self.get_waivers( rest_limit = "10")
    @agent = Agent.new(@@api_key, @@api_version, rest_limit, @@base_url) 
    return @agent.request
  end
  
  # Retrieves individual waiver from the Smartwaiver API.
  #
  # @param [String] waiver_id ID of waiver to retrieve, eg "21"
  def self.get_waiver( waiver_id )
    @agent = Agent.new(@@webhook_private_key, @@api_version, false, @@base_url)
    
    require 'open-uri'
    return @agent.request( "&rest_waiverid=#{URI::encode(waiver_id)}" )
  end  

  # Retrieves list of waiver types from the Smartwaiver API.
  #
  # @param [String] rest_limit Number of records to retrieve, eg "10"
  def self.get_waivertypes( rest_limit = "10")
    @agent = Agent.new(@@api_key, @@api_version, rest_limit, @@base_url) 
    return @agent.request( "&resetapi_listofwaivertypes" )
  end
  
  # Download a PDF from Smartwaiver
  #
  # @param [String] pdf_url Encrypted PDF URL provided in the get_waivers method, eg "NTE0OWZjMDdhYzIzMnx8fGNiMjRmZjZlZWMwZjg4YzVkZDBjYzVjMDMwZjI5MzQy"  
  def self.download_pdf( pdf_url = "")
    @agent = Agent.new(@@api_key, @@api_version, false, @@base_url) 
    return @agent.download_pdf( pdf_url )
  end

  # Verify credentials from webhook
  #
  # @param [String] unique_id Unique ID for an event, which is verified by hashing, eg "5176c8b298d9f"  
  def self.hashed_credential( unique_id = "" )
    return Digest::MD5.hexdigest( @@api_key + unique_id )
  end
  
end