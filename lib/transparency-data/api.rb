module TransparencyData
  class Api
    include HTTParty
    base_uri 'transparencydata.com/api/1.0'
    
    def initialize(key)
      self.class.default_params :apikey => key
    end
    
  end
end