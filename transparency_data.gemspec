Gem::Specification.new do |s|
  s.name              = "transparency_data"
  s.version           = "0.0.1"
  s.date              = "2010-05-06"
  s.summary           = "Wrapper for the Sunlight Transparency data API"
  s.description       = "Wrapper for the Sunlight Transparency data API"
  s.homepage          = "http://github.com/pengwynn/transparency_data"
  s.email             = ["wynn.netherland@gmail.com", "jeremy@hinegardner.org", "luigi.montanez@gmail.com"]
  s.authors           = [
    "Wynn Netherland",
    "Jeremy Hinegardner",
    "Luigi Montanez",
  ]
  s.has_rdoc          = false
  s.files             = %w[README.md lib/transparency_data.rb lib/transparency_data/client.rb]
  s.add_dependency("rake")
  s.add_dependency("monster_mash", "~> 0.1.0")
  s.add_dependency("hashie", "~> 0.2.0")
  s.add_development_dependency("yard", ">= 0")
  s.add_development_dependency("shoulda", ">= 2.10.1")
  s.add_development_dependency("jnunemaker-matchy", "= 0.4.0")
  s.add_development_dependency("fakeweb", ">= 1.2.5")
  s.add_development_dependency("vcr", ">= 0.4.1")
  s.add_development_dependency("mg", ">= 0.0.8")
  s.add_development_dependency("mocha", ">= 0.9.8")
end
