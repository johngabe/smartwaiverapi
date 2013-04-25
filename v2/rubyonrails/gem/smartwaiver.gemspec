Gem::Specification.new do |s|
  s.name        = 'smartwaiver'
  s.version     = '0.0.4'
  s.date        = '2013-05-23'
  s.summary     = "Interface for SmartWaiver API"
  s.description = "Interface for SmartWaiver API"
  s.authors     = ["Lotus Partners"]
  s.email       = 'sales@lotuspartners.sg'
  s.files       = ["lib/smartwaiver.rb", "lib/smartwaiver/agent.rb"]
  s.homepage    = 'http://rubygems.org/gems/smartwaiver'
  s.add_runtime_dependency "mechanize", [">= 0"]
end