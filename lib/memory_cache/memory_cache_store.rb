module MemoryCache
  # A processor level in memory cache storage. Data is not across multiple processes
  class MemoryCacheStore
    def initialize
      @data = {}
      @key_access_store = {}
      @lock = Monitor.new
    end


    # write a key with value
    # return true if success, false if any exception
    def write(key, value, options = {})
      synchronize_block do
        @data[key] = value
        @key_access_store[key] = Time.now.utc.to_i
        return true
      end
    end

    # read a key value from store
    # return value of the key
    def read(key, options = {})
      synchronize_block do
        @key_access_store[key] = Time.now.utc.to_i
        return @data[key] ? @data[key].dup : nil
      end
    end

     # delete key from store
    def delete(key, options = {})
      @data.delete(key)
      @key_access_store.delete(key)
    end

    # Synchronize calls to the cache for thread safety
    def synchronize_block(&block)
      @lock.synchronize(&block)
    end

    # flushed the data store
    def clear
      synchronize_block do
        @data.clear
        @key_access_store.clear
      end
    end

  end
end