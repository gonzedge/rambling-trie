# frozen_string_literal: true

namespace :ips do
  task :each_char_shovel_vs_chars_map do
    compare_each_char_shovel_vs_chars_map
  end

  task :string_pop_shift_slice do
    compare_string_pop_shift_slice
  end

  task :pop_shift_slice do
    compare_pop_shift_slice
  end

  task :array_hash_keys do
    compare_symbols_with_array_hash_keys
  end

  task :hash_has_key_or_direct do
    compare_has_key_with_square_brackets
  end

  task :attr_accessor_vs_def_method do
    compare_attr_accessor_with_def_method
  end

  task :delegate_vs_direct do
    compare_delegate_custom_and_direct
  end

  task :alias_vs_alias_method do
    compare_alias_vs_alias_method
  end

  task :dup_vs_clone do
    compare_dup_vs_clone
  end
end

def compare
  require 'benchmark/ips'
  Benchmark.ips do |bm|
    yield bm

    bm.compare!
  end
end

def compare_each_char_shovel_vs_chars_map
  compare do |bm|
    word = 'awesome'

    bm.report 'each_char and <<' do
      symbols = []
      word.reverse.each_char { |char| symbols << char.to_sym }
      symbols.to_a
    end

    bm.report 'chars map' do
      word.reverse.chars.map(&:to_sym).to_a
    end
  end
end

def compare_string_pop_shift_slice
  compare do |bm|
    a = ''
    bm.report('<<') { a << 'a' }
    bm.report('pop') { a.chars.pop }

    a.clear
    bm.report('<<') { a << 'a' }
    bm.report('shift') { a.chars.shift }

    a.clear
    bm.report('<<') { a << 'a' }
    bm.report('slice!(0)') { a.slice! 0 }
  end
end

def compare_pop_shift_slice
  compare do |bm|
    a = []
    bm.report('push') { a.push 1 }
    bm.report('pop') { a.pop }

    a.clear
    bm.report('unshift') { a.unshift 1 }
    bm.report('shift') { a.shift }

    a.clear
    bm.report('shovel(<<)') { a << 1 }
    bm.report('slice!(0)') { a.slice! 0 }
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

def compare_has_key_with_square_brackets
  compare do |bm|
    hash = { thing: 'gniht' }

    bm.report 'key?' do
      hash.key? :thing
    end

    bm.report 'has_key?' do
      hash.has_key? :thing
    end

    bm.report '[]' do
      !!hash[:thing]
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

  delegate %i([]) => :hash

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

  delegate %i([]) => :hash

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

class TestAlias
  def initialize hash
    @hash = hash
  end

  def [] key
    hash[key]
  end

  alias get []

  private

  attr_reader :hash
end

class TestAliasMethod
  def initialize hash
    @hash = hash
  end

  def [] key
    hash[key]
  end

  alias_method :get, :[]

  private

  attr_reader :hash
end

def compare_alias_vs_alias_method
  compare do |bm|
    hash = { key: 'value' }

    alias_test = TestAlias.new hash
    bm.report 'alias' do
      alias_test.get :key
    end

    alias_method_test = TestAliasMethod.new hash
    bm.report 'alias_method' do
      alias_method_test.get :key
    end
  end
end

def compare_dup_vs_clone
  compare do |bm|
    s = 'hello'

    bm.report 'dup' do
      s.dup
    end

    bm.report 'clone' do
      s.clone
    end

    bm.report 'slice' do
      s.slice 0, s.size
    end
  end
end
