module MemoryCache
  # A processor level in memory cache storage. Data is not across multiple processes. Thread-safe
  class MemoryCacheStore

    MEGABYTE = 1024 * 1024

    def initialize
      @data = {}
      @key_access_store = {}
      @lock = Monitor.new
      @cache_size = 0
      @max_size = 25 * MEGABYTE
      @buffer_size = 5 * MEGABYTE
      @max_wait_loop_for_flush = 100
      @max_single_value_limit = 2 * MEGABYTE
    end


    # write a key with value
    # return true if success, false if any exception
    def write(key, value, options = {})
      synchronize_block do
        return false unless can_allocate_value?(value)
        prune_keys(@buffer_size) if is_buffer_limit_reached?

        old_value_present = false

        if key_exists?(key)
          old_value_present = true
          old_value = @data[key]
          old_value_size = compute_value_size(old_value)
        end

        @data[key] = value
        set_key_access_strategy(key)
        @cache_size -= old_value_size if old_value_present
        @cache_size += compute_value_size(value)
        return true
      end
    end

    # read a key value from store
    # return value of the key
    def read(key, options = {})
      synchronize_block do
        set_key_access_strategy(key)
        return @data[key] ? dup_value(@data[key]) : nil
      end
    end

     # delete key from store
    def delete(key, options = {})
      old_key_present = key_exists?(key)
      value = @data[key]
      @data.delete(key)
      @key_access_store.delete(key)
      @cache_size -= compute_value_size(value) if @cache_size > 0 && old_key_present
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

    def key_exists?(key)
      @data.key?(key)
    end

    private

    def prune_keys(new_allocate_size = 0)
      keys = prune_keys_in_order
      loop_counter = 0
      keys.each do |key|
        delete(key)
        return if available_size > new_allocate_size
        if loop_counter >= @max_wait_loop_for_flush
          clear
          return
        end
        loop_counter += 1
      end
    end

    def compute_value_size(value = '')
      value.to_s.bytesize
    end

    def available_size
      size = @max_size - @cache_size
      size < 0 ? 0 : size
    end

    def is_buffer_limit_reached?
      available_size <= @buffer_size
    end

    def can_allocate_value?(value = '')
      value.to_s.bytesize < @max_single_value_limit
    end

    def dup_value(value)
      value.is_a?(String) ? value.dup : value
    end

    def set_key_access_strategy(key)
      @key_access_store[key] = Time.now.utc.to_i
    end

    def prune_keys_in_order
      synchronize_block { @key_access_store.keys.sort { |a, b| @key_access_store[a] <=> @key_access_store[b] } }
    end

  end
end