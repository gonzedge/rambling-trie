# frozen_string_literal: true

namespace :ips do
  task :string_slice_vs_brackets do
    compare_string_slice_vs_brackets
  end

  task :slice_vs_brackets do
    compare_slice_vs_brackets
  end

  task :assign_variable_vs_not do
    compare_assign_variable_vs_not
  end

  task :string_shovel_plus_interpolation do
    compare_string_shovel_plus_interpolation
  end

  task :hash_assign_vs_inject do
    compare_hash_assign_vs_inject
  end

  task :do_end_vs_brackets do
    compare_do_end_vs_brackets
  end

  task :nil_check_vs_not do
    compare_nil_check_vs_not
  end

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

def compare_string_slice_vs_brackets
  compare do |bm|
    bm.config time: 20, warmup: 2

    string = 'a string with many characters to test performance of slice(i, j) vs slice(i..j) vs [i..j]'
    size = string.size

    bm.report 'slice(i, slice_size)' do
      i = Random.rand size
      slice_size = Random.rand size
      string.slice i, slice_size
    end

    bm.report 'slice(i..j)' do
      i = Random.rand size
      slice_size = Random.rand size
      string.slice i..(i + slice_size)
    end

    bm.report '[i..j]' do
      i = Random.rand size
      slice_size = Random.rand size
      string[i..(i + slice_size)]
    end
  end
end

def compare_slice_vs_brackets
  compare do |bm|
    bm.config time: 20, warmup: 2

    array = %w(t h i s i s a n a r r a y o f c h a r s t o f i g u r e o u t w h a t i s f a s t)
    size = array.size

    bm.report 'slice(i, slice_size)' do
      i = Random.rand size
      slice_size = Random.rand size
      array.slice i, slice_size
    end

    bm.report 'slice(i..j)' do
      i = Random.rand size
      slice_size = Random.rand size
      array.slice i..(i + slice_size)
    end

    bm.report '[i..j]' do
      i = Random.rand size
      slice_size = Random.rand size
      array[i..(i + slice_size)]
    end
  end
end

def compare_assign_variable_vs_not
  compare do |bm|
    bm.config time: 20, warmup: 2
    a = 1

    bm.report 'assign var' do
      b = 2
      a + b
    end

    bm.report 'no var' do
      a + 2
    end
  end
end

def compare_string_shovel_plus_interpolation
  compare do |bm|
    bm.report '<<' do
      a = 'hey'.chars.join
      a << 'there'
    end

    bm.report '+' do
      a = 'hey'.chars.join
      a + 'there'
    end

    bm.report 'interpolation' do
      a = 'hey'.chars.join
      "#{a}there"
    end
  end
end

def compare_hash_assign_vs_inject
  compare do |bm|
    a = { hello: 'there', how: 'do', you: 'do', fellow: 'kids' }

    bm.report 'var assign' do
      new_hash = {}
      a.each { |key, value| new_hash[key] = "#{value}-new" }
      new_hash
    end

    bm.report 'inject' do
      a.inject({}) { |new_hash, entry| new_hash[entry[0]] = "#{entry[1]}-new"; new_hash }
    end

    bm.report 'each_with_object' do
      a.each_with_object({}) { |entry, new_hash| new_hash[entry[0]] = "#{entry[1]}-new" }
    end
  end
end

def compare_do_end_vs_brackets
  compare do |bm|
    bm.config time: 20, warmup: 5
    a = [1, 2, 3] * 100

    bm.report('do/end') do
      a.map do |i|
        1 <= i
      end
    end

    bm.report('{ }') do
      a.map { |i| 1 <= i }
    end
  end
end

def compare_nil_check_vs_not
  compare do |bm|
    value = nil

    bm.report('value.nil?') { value.nil? }
    bm.report('!value') { !value }
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
  pop = ''.chars.join
  shift = ''.chars.join
  slice = ''.chars.join
  compare do |bm|
    bm.report('<<') do
      pop << 'a'
      shift << 'b'
      slice << 'c'
    end
  end

  compare do |bm|
    bm.report('pop') do
      pop_chars = pop.chars
      pop_chars.pop
      pop_chars.join
    end

    bm.report('shift') do
      shift_chars = shift.chars
      shift_chars.shift
      shift_chars.join
    end

    bm.report('slice!(0)') { slice.slice! 0 }
  end
end

def compare_pop_shift_slice
  push_pop = []
  unshift_shift = []
  shovel_slice = []
  compare do |bm|
    bm.report('push') do
      push_pop.push 1
      push_pop.push 2
    end
    bm.report('unshift') do
      unshift_shift.unshift 1
      unshift_shift.unshift 2
    end
    bm.report('shovel(<<)') do
      shovel_slice << 1
      shovel_slice << 2
    end
  end

  compare do |bm|
    bm.report('pop') do
      2.times { push_pop.pop }
    end
    bm.report('shift') do
      unshift_shift.shift 2
    end
    bm.report('slice!(0)') do
      shovel_slice.slice! 0, 2
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
