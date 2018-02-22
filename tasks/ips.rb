# frozen_string_literal: true

require 'benchmark/ips'

namespace :ips do
  task :pop_shift_slice do
    Benchmark.ips do |bm|
      a = []
      1.upto(100).each { |i| a.push i }

      bm.report 'pop' do
        a.pop while !a.empty?
      end

      b = []
      1.upto(100).each { |i| b.unshift i }

      bm.report 'shift' do
        b.shift while !a.empty?
      end

      c = []
      1.upto(100).each { |i| c << i }

      bm.report 'slice!(0)' do
        c.slice!(0) while !a.empty?
      end

      bm.compare!
    end
  end

  task :array_hash_keys do
    Benchmark.ips do |bm|
      h = {
        hello: true,
        %i(h e l l o) => true
      }

      chars = %w(o l l e h)
      bm.report 'build up symbol letter by letter' do
        s = ''
        s += chars.pop while !chars.empty? && !h[s.to_sym]
      end

      symbols = %i(o l l e h)
      bm.report 'build up array of symbols letter by letter' do
        s = []
        s << symbols.pop while !symbols.empty? && !h[s]
      end

      bm.compare!
    end
  end

  task :hash_has_key_or_direct do
    Benchmark.ips do |bm|
      hash = { 'thing' => 'gniht' }

      bm.report 'has_key?' do
        hash.has_key? 'thing'
      end

      bm.report '[]' do
        !!hash['thing']
      end

      bm.compare!
    end
  end

  task :attr_accessor_vs_def_method do
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

    Benchmark.ips do |bm|
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

      bm.compare!
    end
  end

  task :delegate_vs_direct do
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

    Benchmark.ips do |bm|
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

      bm.compare!
    end
  end
end
