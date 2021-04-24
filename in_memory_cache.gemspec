Gem::Specification.new do |s|
  s.name        = 'in_memory_cache'
  s.version     = '1.1'
  s.date        = '2021-03-31'
  s.summary     = "Ruby In memory cache"
  s.description = "A simple gem for in memory LRU cache"
  s.authors     = ["kathir"]
  s.email       = 'kathirvalavan.ict@gmail.com'
  s.files       = ["lib/memory_cache/memory_cache_store.rb"]
  s.homepage    =
      'https://rubygems.org/gems/memory_cache_store'
  s.license       = 'MIT'
  s.metadata    = { "source_code_uri" => "https://github.com/kathirvalavan/in_memory_cache" }
  s.required_ruby_version = ">= 2.3"

  s.add_development_dependency "bundler", "~> 1.17"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"

end