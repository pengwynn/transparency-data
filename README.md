# TransparencyData.com Ruby Wrapper

By Wynn Netherland, Jeremy Hinegardner, and Luigi Montanez

Before using this library, please read the official [TransparencyData.com API documentation](http://transparencydata.com/api/). Query parameters and return formats are described there.

## Setup

Get an API key from [Sunlight Labs](http://services.sunlightlabs.com/).

After a `gem install transparency_data`, you can do:

    require 'transparency_data'
    TransparencyData.api_key = 'YOUR_KEY_HERE'
      
Within a Rails app, create a `config/initializers/transparency_data.rb` and stick this in:

    TransparencyData.configure do |config|
     config.api_key = 'YOUR_KEY_HERE'
    end

## Usage

See the official API docs for all parameters, but usage is quite simple:

    contributions = TransparencyData::Client.contributions(:contributor_ft => 'steve jobs')
    contributions.each do |contribution|
      # do something
    end
    
    lobbyings = TransparencyData::Client.lobbying(:client_ft => "apple inc")
    lobbyings.each do |lobbying|
      # do something
    end
    
