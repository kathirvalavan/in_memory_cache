  # Simple Thread-safe in memory LRU cache for ruby. Dev in progress
    1. To init, cache_store = MemoryCache::MemoryCacheStore.new
    2. cache_store.write('key1', 'value1') => return true or false
    3. cache_store.read('key1')
    4. cache_store.delete('key1')
    5.cache_store.clear => flushes the store

    # LFU cache:
      
      1. To init, cache_store = MemoryCache::MemoryLfuCacheStore.new
      2. cache_store.write('key1', 'value1') => return true or false
      3. cache_store.read('key1')
      4. cache_store.delete('key1')
      5.cache_store.clear => flushes the store
