Gem::Specification.new do |s|
  s.name          = 'logstash-filter-throttle-prop'
  s.version       = '0.1.3'
  s.licenses      = ['Apache License (2.0)']
  s.description   = 'A logstash filter plugin to throttle events per properties'
  s.summary       = s.description
  s.homepage      = 'https://github.com/JeanPinzon/logstash-filter-throttle-prop'
  s.authors       = ['jeanpinzon']
  s.email         = 'jean.pinzon1@gmail.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_development_dependency 'logstash-devutils'
end
