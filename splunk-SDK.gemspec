Gem::Specification.new do |s|
    s.name        = 'splunk-SDK'
    s.version     = '0.0.0'
    s.date        = '2020-06-05'
    s.summary     = "A Splunk Gem to replace Splunk's deprecated Ruby SDK"
    s.description = "A simple interface to provide easy access to Splunk through its REST API. A specialized search method is also written to make sure all data is returned."
    s.authors     = ["Matthew Hu"]
    s.email       = 'matt.hu017@gmail.com'
    s.files       = Dir.glob("lib/*") + %w(LICENSE README.mdGemfile Gemfile.lock)
    s.homepage    = 'https://rubygems.org/gems/splunk-SDK' #Homepage when pushing to rubygems
    s.license       = 'MIT'
  end