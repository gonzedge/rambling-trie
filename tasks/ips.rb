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
    class TestClassOne
      attr_accessor :uno, :dos

      def initialize uno, dos
        @uno = uno
        @dos = dos
      end
    end

    class TestClassTwo
      def initialize uno, dos
        @uno = uno
        @dos = dos
      end

      def uno
        @uno
      end

      def uno= uno
        @uno = uno
      end

      def dos
        @dos
      end

      def dos= dos
        @dos = dos
      end
    end

    Benchmark.ips do |bm|
      t1 = TestClassOne.new 1, 2
      t2 = TestClassTwo.new 1, 2

      bm.report 'attr_x' do
        t1.uno = 1
        t1.dos = 2
        t1.uno
        t1.dos
      end

      bm.report 'def method' do
        t2.uno = 1
        t2.dos = 2
        t2.uno
        t2.dos
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
