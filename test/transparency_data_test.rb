require File.dirname(__FILE__) + '/helper'

class TransparencyDataTest < Test::Unit::TestCase
  
  context "when consuming the Sunlight Transparency Data API" do
    
    should "should set the API key on the module" do
      TransparencyData.configure do |config|
        config.api_key = "OU812"
      end
      assert_equal TransparencyData.api_key, "OU812"
    end
    
    should "provide helpers for URLs" do
      assert_equal TransparencyData.api_url("/contributions"), "http://#{TransparencyData.api_domain}/api/1.0/contributions.json"
    end
    
  end
end