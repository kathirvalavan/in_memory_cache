require 'spec_helper'

describe MemoryCache::MemoryLfuCacheStore do

  it 'test all basic functionality cache read/write/delete' do
    memory_cache = MemoryCache::MemoryLfuCacheStore.new
    write_status = memory_cache.write('key1', 'value1')
    expect(write_status).to eq true
    read_value = memory_cache.read('key1')
    expect(read_value).to eq 'value1'
    memory_cache.delete('key1')
    read_value = memory_cache.read('key1')
    expect(read_value).to eq nil
    memory_cache.write('key1', 'value1')
    memory_cache.clear
    read_value = memory_cache.read('key1')
    expect(read_value).to eq nil
    memory_cache.instance_variable_set(:@max_single_value_limit, 5)
    write_status = memory_cache.write('key1', 'value1111')
    expect(write_status).to eq false
  end

  context 'it should test all pruning functionality of LFU cache' do

    it 'should delete least frequently used keys in case of limit reach' do
      memory_cache = MemoryCache::MemoryLfuCacheStore.new
      memory_cache.instance_variable_set(:@max_size, 10)
      memory_cache.instance_variable_set(:@buffer_size, 4)
      values = [rand(10..20), rand(10..20), rand(1000..2000), rand(1000..2000),  rand(1000..2000)]

      values.each_with_index { |value, i|
        memory_cache.write("#{i}", value)
        (i + 1).times do
          memory_cache.read("#{i}")
        end
      }

      expect(memory_cache.read("0").nil?).to eq true
      expect(memory_cache.read("1").nil?).to eq true
      expect(memory_cache.read("2").nil?).to eq true
      expect(memory_cache.read("3").nil?).to eq false
      expect(memory_cache.read("4").nil?).to eq false
    end

    it 'should flush all keys if maximum loop in readched' do
      memory_cache = MemoryCache::MemoryLfuCacheStore.new
      memory_cache.instance_variable_set(:@max_size, 10)
      memory_cache.instance_variable_set(:@max_wait_loop_for_flush, 3)
      memory_cache.instance_variable_set(:@buffer_size, 9)
      values = [rand(0..9), rand(0..9), rand(0..9), rand(10..99), "1111111"]

      values.each_with_index { |value, i|
        memory_cache.write("#{i}", value)
      }

      expect(memory_cache.read("0").nil?).to eq true
      expect(memory_cache.read("1").nil?).to eq true
      expect(memory_cache.read("2").nil?).to eq true
      expect(memory_cache.read("3").nil?).to eq true
      expect(memory_cache.read("4").nil?).to eq false
    end

  end
end