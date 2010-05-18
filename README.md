# TransparencyData.com Ruby Wrapper

By Wynn Netherland, Jeremy Hinegardner, and Luigi Montanez

Before using this library, please read the official [TransparencyData.com API documentation](http://transparencydata.com/api/). Query parameters and return formats are described there.

## Setup

Get an API key from [Sunlight Labs](http://services.sunlightlabs.com/).

Required gems:

* monster_mash
* hashie

After a `gem install transparency_data`, you can do:

    require 'transparency_data'
    TransparencyData.api_key = 'YOUR_KEY_HERE'
      
Within a Rails app, create a `config/initializers/transparency_data.rb` and stick this in:

    TransparencyData.configure do |config|
     config.api_key = 'YOUR_KEY_HERE'
    end

## Usage

See the official [API docs](http://transparencydata.com/api/) for all parameters you can send in, and the [schema docs](http://transparencydata.com/docs/) for what you get back:

    contributions = TransparencyData::Client.contributions(:contributor_ft => 'steve jobs')
    contributions.each do |contribution|
      puts "Amount: #{contribution.amount}"
      puts "Date: #{contribution.date}"
    end
    
    lobbyings = TransparencyData::Client.lobbying(:client_ft => "apple inc")
    lobbyings.each do |lobbying|
      puts "Amount: #{lobbying.amount}"
      puts "Year: #{lobbying.year}"
    end

As described in the API docs, the TransparencyData.com API supports a special syntax as the parameter value for specifying ranges and sets on amount, cycle, year, and date. You can either pass in strings, or use a more Rubyish approach:

    # contributions with an amount greater than or equal to $1000
    TransparencyData::Client.contributions(:contributor_ft => 'steve jobs', :amount => {:gte => 1000})

    # contributions with an amount less than or equal to $500
    TransparencyData::Client.contributions(:contributor_ft => 'bill gates', :amount => {:lte => 500})
    
    # contributions in the 2006 or 2008 cycle
    TransparencyData::Client.contributions(:contributor_ft => 'eric schmidt', :cycle => [2006,2008]})

    # contributions to Obama made between in Q1 2008
    TransparencyData::Client.contributions(:recipient_ft => 'barack obama',
                                           :date => {:between => ['2008-01-01','2008-03-31']})
                                           
## Contributing

Required gems for running tests:

* mg
* shoulda
* jnunemaker-matchy
* mocha
* fakeweb
* vcr

Run the test suite:

    rake test