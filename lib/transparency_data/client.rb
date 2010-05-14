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
    
  end
end