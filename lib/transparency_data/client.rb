module TransparencyData
  class Client < MonsterMash::Base
    
    defaults do
      params :apikey => TransparencyData.api_key
    end
    
    get(:contributions) do |api_params|
      uri TransparencyData.api_url("/contributions")
      params TransparencyData::Client.prepare_params(api_params)
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end
    
    get(:lobbying) do |api_params|
      uri TransparencyData.api_url("/lobbying")
      params TransparencyData::Client.prepare_params(api_params)
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end
    
    get(:entities) do |api_params|
      uri TransparencyData.api_url("/entities")
      params TransparencyData::Client.prepare_params(api_params)
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end
    
    get(:id_lookup) do |api_params|
      uri TransparencyData.api_url("/entities/id_lookup")
      params TransparencyData::Client.prepare_params(api_params)
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end
    
    get(:entity) do |id, api_params|
      uri TransparencyData.api_url("/entities/#{id}")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        Hashie::Mash.new(JSON.parse(response.body))
      end
    end
    
    get(:top_contributors) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/pol/#{id}/contributors")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end

    get(:top_sectors) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/pol/#{id}/contributors/sectors")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        sectors = TransparencyData::Client.handle_response(response)
        TransparencyData::Client.process_sectors(sectors)
      end
    end

    get(:top_industries) do |id, sector, api_params|
      uri TransparencyData.api_url("/aggregates/pol/#{id}/contributors/sector/#{sector}/industries")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end


    get(:local_breakdown) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/pol/#{id}/contributors/local_breakdown")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        TransparencyData::Client.process_local_breakdown(breakdown)
      end
    end

    get(:contributor_type_breakdown) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/pol/#{id}/contributors/type_breakdown")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        TransparencyData::Client.process_contributor_type_breakdown(breakdown)
      end
    end

    get(:top_recipient_orgs) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/indiv/#{id}/recipient_orgs")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end

    get(:top_recipient_pols) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/indiv/#{id}/recipient_pols")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end

    get(:individual_party_breakdown) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/indiv/#{id}/recipients/party_breakdown")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        TransparencyData::Client.process_party_breakdown(breakdown)
      end
    end

    get(:top_org_recipients) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/org/#{id}/recipients")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        TransparencyData::Client.handle_response(response)
      end
    end

    get(:org_party_breakdown) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/org/#{id}/recipients/party_breakdown")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        TransparencyData::Client.process_org_party_breakdown(breakdown)
      end
    end

    get(:org_level_breakdown) do |id, api_params|
      uri TransparencyData.api_url("/aggregates/org/#{id}/recipients/level_breakdown")
      params TransparencyData::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        TransparencyData::Client.process_org_level_breakdown(breakdown)
      end
    end

    def self.prepare_params(params)
      params.each do |key, value|
        if value.is_a?(Hash)
          
          case value.keys.first
          when :gte
            params[key] = ">|#{value.values.first}"
          when :lte
            params[key] = "<|#{value.values.first}"
          when :between
            params[key] = "><|#{value.values.first.join('|')}"
          end
          
        elsif value.is_a?(Array)
          params[key] = value.join("|")
        end
      end
      params
    end
    
    def self.handle_response(response)
      # TODO: raise_errors
      JSON.parse(response.body).map {|c| Hashie::Mash.new(c)}
    end
    
    def self.process_sectors(sectors)
      sectors.each do |sector|
        sector["name"] = case sector.sector
          when "A" then "Agribusiness"
          when "B" then "Communications/Electronics"
          when "C" then "Construction"
          when "D" then "Defense"
          when "E" then "Energy/Natural Resources"
          when "F" then "Finance/Insurance/Real Estate"
          when "H" then "Health"
          when "K" then "Lawyers/Lobbyists"
          when "M" then "Transportation"
          when "N" then "Misc. Business"
          when "Q" then "Ideology/Single Issue"
          when "P" then "Labor"
          when "W" then "Other"
          when "Y" then "Unknown"
          when "Z" then "Administrative Use"
        end
      end
    end
    
    def self.process_local_breakdown(breakdown)
      TransparencyData::Client.mashize_key(breakdown, "in-state", "in_state")
      TransparencyData::Client.mashize_key(breakdown, "out-of-state", "out_of_state")
      breakdown
    end
    
    def self.process_contributor_type_breakdown(breakdown)
      TransparencyData::Client.mashize_key(breakdown, "Individuals", "individual")
      TransparencyData::Client.mashize_key(breakdown, "PACs", "pac")
      breakdown
    end
    
    def self.process_party_breakdown(breakdown)
      TransparencyData::Client.mashize_key(breakdown, "D", "dem")
      TransparencyData::Client.mashize_key(breakdown, "R", "rep")
      TransparencyData::Client.mashize_key(breakdown, "L", "lib")
      TransparencyData::Client.mashize_key(breakdown, "I", "ind")
      TransparencyData::Client.mashize_key(breakdown, "U", "unknown")
      TransparencyData::Client.mashize_key(breakdown, "U", "other")
      TransparencyData::Client.mashize_key(breakdown, "3", "third")
      breakdown
    end

    def self.process_org_party_breakdown(breakdown)
      TransparencyData::Client.mashize_key(breakdown, "Democrats", "dem")
      TransparencyData::Client.mashize_key(breakdown, "Republicans", "rep")
      TransparencyData::Client.mashize_key(breakdown, "L", "lib")
      TransparencyData::Client.mashize_key(breakdown, "I", "ind")
      TransparencyData::Client.mashize_key(breakdown, "U", "unknown")
      TransparencyData::Client.mashize_key(breakdown, "U", "other")
      TransparencyData::Client.mashize_key(breakdown, "3", "third")
      breakdown
    end
    
    def self.process_org_level_breakdown(breakdown)
      TransparencyData::Client.mashize_key(breakdown, "State", "state")
      TransparencyData::Client.mashize_key(breakdown, "Federal", "federal")
      breakdown
    end
    
    def self.mashize_key(breakdown, api_key, mash_key)
      if breakdown[api_key]
        breakdown["#{mash_key}_count"]  = breakdown[api_key][0].to_i
        breakdown["#{mash_key}_amount"]  = breakdown[api_key][1].to_f
      end
    end

  end
end