module Rambling
  class Trie < TrieNode
    def initialize(filename = nil)
      super(nil)

      @filename = filename
      @is_compressed = false
      add_all_nodes if filename
    end

    def compress!
      unless compressed?
        compress_own_tree!
        @is_compressed = true
      end

      self
    end

    def compressed?
      @is_compressed = @is_compressed.nil? ? false : @is_compressed
    end

    def has_branch_for?(word = '')
      compressed? ? has_compressed_branch_for?(word) : has_uncompressed_branch_for?(word)
    end

    def is_word?(word = '')
      compressed? ? is_compressed_word?(word) : is_uncompressed_word?(word)
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
