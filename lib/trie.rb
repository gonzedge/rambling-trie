module Rambling
  class Trie < TrieNode
    def initialize(filename = nil)
      super(nil)

      @filename = filename
      add_all_nodes if filename
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
