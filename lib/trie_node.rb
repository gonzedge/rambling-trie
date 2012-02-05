module Rambling
  class TrieNode
    attr_reader :letter, :children

    def initialize(word, parent = nil)
      @letter = nil
      @word = ''
      @parent = parent
      @is_terminal = false
      @children = {}

      unless word.nil?
        @letter = word.slice!(0)
        @is_terminal = word.empty?
        @word = get_parent_letter_string if terminal?
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

    def as_word
      raise InvalidTrieOperation.new() unless @letter.nil? or terminal?
      @word
    end

    def add_branch_from(word)
      unless word.empty?
        first_letter = word.slice(0)

        if @children.has_key?(first_letter)
          word.slice!(0)
          @children[first_letter].add_branch_from(word)
        else
          @children[first_letter] = TrieNode.new(word, self)
        end
      end
    end

    def has_branch_for?(word)
      return true if word.empty?
      passes_condition(word) { |node, sliced_word| node.has_branch_for?(sliced_word) }
    end

    def is_word?(word)
      return true if word.empty? and terminal?
      passes_condition(word) { |node, sliced_word| node.is_word?(sliced_word) }
    end

    protected
    def get_parent_letter_string
      if @parent.nil?
        @letter or ''
      else
        @parent.get_parent_letter_string + @letter
      end
    end

    private
    def passes_condition(word, &block)
      first_letter = word.slice!(0)
      return block.call(@children[first_letter], word) if @children.has_key?(first_letter)
      false
    end
  end
end
