require File.dirname(__FILE__) + '/helper'

class ClientTest < Test::Unit::TestCase
  
  context "when consuming the Sunlight Transparency Data API" do
    setup do
      TransparencyData.api_key = "OU812" 
    end
    
    context "when handling parameters" do

      should "map arrays to delimited text" do
        scenarios = [
          [{:date => "2009-03-04"},  {:date => "2009-03-04"}],
          [{:date => ["2009-03-04", "2009-03-06"]}, {:date => "2009-03-04|2009-03-06"}],
          [{:date => {:between => ["2009-03-04", "2009-03-06"] } }, {:date => "><|2009-03-04|2009-03-06"}],
          [{:date => {:gte => "2009-03-04"} }, {:date => ">|2009-03-04"}],
          [{:date => {:lte => "2009-03-04"} }, {:date => "<|2009-03-04"}]
        ]
        scenarios.each do |original, prepared|
          TransparencyData::Client.prepare_params(original).should == prepared
        end
        
        
      end
    end
    
    context "when searching contributions" do


      should "return a list" do
        VCR.use_cassette('contributions', :record => :all) do
          contributions = TransparencyData::Client.contributions(:contributor_ft => 'steve jobs')
          contributions.class.to_s.should == 'Array'
          assert contributions.first.has_key?("amount")
        end
      end
      
      should "find all the money Steve Jobs gave between March 3rd and March 10th 2009" do
        VCR.use_cassette('contributions', :record => :all) do
          contributions = TransparencyData::Client.contributions(:contributor_ft => 'steve jobs', :date => {:between => ["2009-03-04", "2009-03-10"]})
          contributions.class.to_s.should == 'Array'
        end
      end
    end
    
    
    context "when searching lobbyists" do

      should_eventually "return a list of lobbying events" do
        VCR.use_cassette('lobbying events', :record => :all) do
          lobbying = TransparencyData::Client.lobbying(:amount => {:gte => 5000}, :date => {:between => ["2009-03-04", "2009-03-10"]})
          lobbying.class.to_s.should == 'Array'
        end
      end
    end
  end
  
end