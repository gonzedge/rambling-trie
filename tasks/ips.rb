# frozen_string_literal: true

require 'benchmark/ips'

namespace :ips do
  task :pop_shift_slice do
    compare_pop_shift_slice
  end

  task :array_hash_keys do
    compare_symbols_with_array_hash_keys
  end

  task :hash_has_key_or_direct do
    compare_hash_has_key_with_square_brackets
  end

  task :attr_accessor_vs_def_method do
    compare_attr_accessor_with_def_method
  end

  task :delegate_vs_direct do
    compare_delegate_custom_and_direct
  end

end

def compare
  Benchmark.ips do |bm|
    yield bm

    bm.compare!
  end
end

def compare_pop_shift_slice
  compare do |bm|
    a = []

    bm.report 'push/pop' do
      a.push 1
      a.pop
    end

    bm.report 'unshift/shift' do
      a.unshift 1
      a.shift
    end

    bm.report 'shovel(<<)/slice!(0)' do
      a << 1
      a.slice! 0
    end
  end
end

def array_of total
  1.upto(total).to_a
end

def compare_symbols_with_array_hash_keys
  compare do |bm|
    h = { hello: true, %i(h e l l o) => true }

    bm.report 'build up symbol letter by letter' do
      chars = %w(o l l e h)
      key = ''
      key += chars.pop until chars.empty? && !h[key.to_sym]
    end

    bm.report 'build up array of symbols letter by letter' do
      symbols = %i(o l l e h)
      key = []
      key << symbols.pop until symbols.empty? && !h[key]
    end
  end
end

def compare_hash_has_key_with_square_brackets
  compare do |bm|
    hash = { 'thing' => 'gniht' }

    bm.report 'key?' do
      hash.key? 'thing'
    end

    bm.report 'has_key?' do
      hash.has_key? 'thing'
    end

    bm.report '[]' do
      !!hash['thing']
    end
  end
end

class TestClassAttrAccessor
  attr_accessor :value

  def initialize value
    @value = value
  end
end

class TestClassDefMethod
  def initialize value
    @value = value
  end

  def value
    @value
  end

  def value= value
    @value = value
  end
end

def compare_attr_accessor_with_def_method
  compare do |bm|
    with_attr = TestClassAttrAccessor.new 1
    with_method = TestClassDefMethod.new 1

    bm.report 'attr_accessor' do
      with_attr.value = 1
      with_attr.value
    end

    bm.report 'def method' do
      with_method.value = 1
      with_method.value
    end
  end
end

class TestDelegate
  require 'forwardable'
  extend ::Forwardable

  delegate [:[]] => :hash

  attr_reader :hash

  def initialize hash
    @hash = hash
  end
end

class TestMyForwardable
  module Forwardable
    def delegate methods_to_target
      methods_to_target.each do |methods, target|
        methods.each do |method|
          define_method method do |*args|
            send(target).send method, *args
          end
        end
      end
    end
  end

  extend TestMyForwardable::Forwardable

  delegate [:[]] => :hash

  attr_reader :hash

  def initialize hash
    @hash = hash
  end
end

class TestDirect
  attr_reader :hash

  def initialize hash
    @hash = hash
  end

  def [] key
    hash[key]
  end
end

def compare_delegate_custom_and_direct
  compare do |bm|
    hash = { h: 'hello' }
    delegate = TestDelegate.new hash
    custom = TestMyForwardable.new hash
    direct = TestDirect.new hash

    bm.report 'delegate access' do
      delegate[:h]
    end

    bm.report 'custom delegate access' do
      custom[:h]
    end

    bm.report 'direct access' do
      direct[:h]
    end
  end
end

