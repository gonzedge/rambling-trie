module Rambling
  class Trie < TrieNode
    def initialize(filename = nil)
      super(nil)

      @filename = filename
      @is_compressed = false
      add_all_nodes if filename
    end

    def compress!
      compress_own_tree!
      @is_compressed = true

      self
    end

    def compressed?
      @is_compressed
    end

    private
    def add_all_nodes
      File.open(@filename) do |file|
        while word = file.gets
          add_branch_from(word.chomp)
        end
      end
    end
  end
end
