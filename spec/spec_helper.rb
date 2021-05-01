require 'bundler/setup'
Bundler.setup

require_relative '../lib/memory_cache/memory_cache_store'
require_relative '../lib/memory_cache/memory_lfu_cache_store'

RSpec.configure do |config|
  # some (optional) config here
end