module MemoryCache
  class MemoryLfuCacheStore < MemoryCache::MemoryCacheStore

    private

    def set_key_access_strategy(key)
      @key_access_store[key] ||= 0
      @key_access_store[key] += 1
    end

    def prune_keys_in_order
      synchronize_block { @key_access_store.keys.sort { |a, b| @key_access_store[a] <=> @key_access_store[b] } }
    end

  end
end