require File.dirname(__FILE__) + '/helper'

class ClientTest < Test::Unit::TestCase
  
  context "when consuming the Sunlight Transparency Data API" do
    
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
        VCR.use_cassette('contributions') do
          contributions = TransparencyData::Client.contributions(:contributor_ft => 'steve jobs')
          contributions.class.should == Array
          assert contributions.first.has_key?("amount")
        end
      end
      
      should "find all the money Steve Jobs gave between March 3rd and March 10th 2009" do
        VCR.use_cassette('contributions in date range') do
          contributions = TransparencyData::Client.contributions(:contributor_ft => 'steve jobs', :date => {:between => ["2009-03-04", "2009-03-10"]})
          contributions.class.should == Array
        end
      end
      
    end
    
    context "when searching lobbyists" do

      should "return a list of lobbying events" do
        VCR.use_cassette('lobbying events') do
          lobbying = TransparencyData::Client.lobbying(:client_ft => "apple inc")
          lobbying.class.should == Array
        end
      end
      
    end
    
    context "when searching entities" do
      
      should "return a list of entities" do
        VCR.use_cassette('entities') do
          entities = TransparencyData::Client.entities(:search => "nancy pelosi")
          entities.class.should == Array
        end
      end
      
    end

    context "when looking up by entity ids" do
      
      should "return a list of entity ids" do
        VCR.use_cassette('entity ids') do
          entity_ids = TransparencyData::Client.id_lookup(:namespace => "urn:crp:recipient", :id => "N00007360")
          entity_ids.class.should == Array
        end
      end
      
    end

    context "when getting one entity" do
      
      should "return an entity" do
        VCR.use_cassette('entity') do
          entity = TransparencyData::Client.entity("ff96aa62d48f48e5a1e284efe74a0ba8")
          entity.name.should == "Nancy Pelosi (D)"
        end
      end
      
    end
    
    context "politician methods" do
      
      should "return a list of top contributors" do
        VCR.use_cassette('top contributors') do
          contributors = TransparencyData::Client.top_contributors("ff96aa62d48f48e5a1e284efe74a0ba8")
          contributors.class.should == Array
          contributors.length.should == 10
        end
      end
      
      should "return a list of 5 top contributors" do
        VCR.use_cassette('top 5 contributors') do
          contributors = TransparencyData::Client.top_contributors("ff96aa62d48f48e5a1e284efe74a0ba8", :limit => 5)
          contributors.class.should == Array
          contributors.length.should == 5
        end
      end
      
      should "return a list of top sectors" do
        VCR.use_cassette('top 5 contributors') do
          sectors = TransparencyData::Client.top_sectors("ff96aa62d48f48e5a1e284efe74a0ba8")
          sectors.class.should == Array
          sectors.first.name.should == "Finance/Insurance/Real Estate"
        end
      end

      should "return a local breakdown" do
        VCR.use_cassette('local breakdown') do
          local_breakdown = TransparencyData::Client.local_breakdown("ff96aa62d48f48e5a1e284efe74a0ba8")
          local_breakdown.in_state_amount.class.should == Float
        end
      end

      should "return a contributor type breakdown" do
        VCR.use_cassette('contributor type breakdown') do
          local_breakdown = TransparencyData::Client.contributor_type_breakdown("ff96aa62d48f48e5a1e284efe74a0ba8")
          local_breakdown.individual_count.class.should == Fixnum
        end
      end

    end

  end
  
end