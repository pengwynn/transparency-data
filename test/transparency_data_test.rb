require File.dirname(__FILE__) + '/helper'

class TransparencyDataTest < Test::Unit::TestCase
  
  context "when consuming the Sunlight Transparency Data API" do
    
    should "should set the API key on the module" do
      TransparencyData.configure do |config|
        config.api_key = "OU812"
      end
      TransparencyData.api_key.should == "OU812"
    end
    
    should "provide helpers for URLs" do
      TransparencyData.api_url("/contributions").should == "http://transparencydata.com/api/1.0/contributions.json"
    end
    
  end
end