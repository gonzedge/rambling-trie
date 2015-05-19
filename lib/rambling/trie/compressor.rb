module Rambling
  module Trie
    class Compressor
      def compress root
        new_root = Rambling::Trie::Root.new
        root.each { |word| new_root.add word }
        new_root.compress!
      end
    end
  end
end
