module Rambling
  class TrieNode
    attr_reader :letter, :children

    def initialize(word)
      @letter = nil
      @is_terminal = false
      @children = {}

      unless word.nil?
        @letter = word.slice!(0)
        @is_terminal = word.empty?
        add_branch_from(word)
      end

    end

    def terminal=(terminal)
      @is_terminal = terminal
    end

    def terminal?
      @is_terminal
    end

    def [](key)
      @children[key]
    end

    def has_key?(key)
      @children.has_key?(key)
    end

    def add_branch_from(word)
      unless word.empty?
        first_letter = word.slice(0)

        if @children.has_key?(first_letter)
          word.slice!(0)
          @children[first_letter].add_branch_from(word)
        else
          @children[first_letter] = TrieNode.new(word)
        end
      end
    end

    def has_branch_tree?(word)
      return true if word.empty?
      passes_condition(word) { |node, sliced_word| node.has_branch_tree?(sliced_word) }
    end

    def is_word?(word)
      return true if word.empty? and terminal?
      passes_condition(word) { |node, sliced_word| node.is_word?(sliced_word) }
    end

    private
    def passes_condition(word, &block)
      first_letter = word.slice!(0)
      return block.call(@children[first_letter], word) if @children.has_key?(first_letter)
      false
    end
  end
end
