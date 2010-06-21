require 'hashie'
require 'json'
require 'monster_mash'

Hash.send :include, Hashie::HashExtensions



module TransparencyData
  
  VERSION = "0.0.1".freeze
  
  # config/initializers/transparency_data.rb (for instance)
  # 
  # TransparencyData.configure do |config|
  #   config.api_key = 'api_key'
  # end
  # 
  def self.configure
    yield self
    true
  end
  
  def self.api_url(endpoint, version = self.api_version)
    "http://transparencydata.com/api/#{version}#{endpoint}.json"
  end

  # class << self
  #   attr_accessor :api_key
  #   attr_accessor :api_version
  # end
  
  def self.api_version
    @api_version || "1.0"
  end
  
  def self.api_version=(value)
    @api_version = value
  end
  
  def self.api_key
    @api_key
  end
  
  def self.api_key=(value)
    @api_key = value
  end

  
end

Dir.glob(File.dirname(__FILE__) + '/transparency_data/*.rb').each { |f| require f }