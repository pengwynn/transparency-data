require File.dirname(__FILE__) + '/helper'

class ClientTest < Test::Unit::TestCase
  
  context "when using Client" do
    
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
        VCR.use_cassette('top sectors') do
          sectors = TransparencyData::Client.top_sectors("ff96aa62d48f48e5a1e284efe74a0ba8")
          sectors.class.should == Array
          sectors.first.name.class.should == String
        end
      end

      should "return a list of top industries within sector" do
        VCR.use_cassette('top industries within sector') do
          industries = TransparencyData::Client.top_industries("ff96aa62d48f48e5a1e284efe74a0ba8","F")
          industries.class.should == Array
          industries.first.count.class.should == Fixnum
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
    
    context "individual (contributor) methods" do

      should "return a list of top recipient organizations" do
        VCR.use_cassette('top recipient organizations') do
          recipient_orgs = TransparencyData::Client.top_recipient_orgs("945bcd0635bc434eacb7abcdcd38abea")
          recipient_orgs.class.should == Array
          recipient_orgs.length.should == 10
        end
      end

      should "return a list of top recipient politicians" do
        VCR.use_cassette('top recipient politicians') do
          recipient_pols = TransparencyData::Client.top_recipient_pols("945bcd0635bc434eacb7abcdcd38abea")
          recipient_pols.class.should == Array
          recipient_pols.length.should == 10
        end
      end
      
      should "return a party breakdown" do
        VCR.use_cassette('individual party breakdown') do
          party_breakdown = TransparencyData::Client.individual_party_breakdown("945bcd0635bc434eacb7abcdcd38abea")
          party_breakdown.dem_count.class.should == Fixnum
        end
      end

    end

    context "organization methods" do

      should "return a list of top organization recipients" do
        VCR.use_cassette('top org recipients') do
          org_recipients = TransparencyData::Client.top_org_recipients("4ef624f6877a49f2b591b2a8af4c5bf5")
          org_recipients.class.should == Array
          org_recipients.length.should == 10
        end
      end
      
      should "return a party breakdown" do
        VCR.use_cassette('org party breakdown') do
          party_breakdown = TransparencyData::Client.org_party_breakdown("4ef624f6877a49f2b591b2a8af4c5bf5")
          party_breakdown.dem_count.class.should == Fixnum
        end
      end
      
      should "return a state/federal level breakdown" do
        VCR.use_cassette('org level breakdown') do
          level_breakdown = TransparencyData::Client.org_level_breakdown("73c18c499c1b4a71b2b042663530e9b7")
          level_breakdown.state_count.class.should == Fixnum
        end
      end

    end

  end
  
end