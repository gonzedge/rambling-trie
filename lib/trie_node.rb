module Rambling
  class TrieNode
    include ChildrenHashDeferer
    include TrieCompressor

    attr_reader :letter, :children, :parent

    def initialize(word, parent = nil)
      @letter = nil
      @parent = parent
      @is_terminal = false
      @children = {}

      unless word.nil?
        letter = word.slice!(0)
        @letter = letter.to_sym unless letter.nil?
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

    def add_branch_from(word)
      unless word.empty?
        first_letter = word.slice(0).to_sym

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
      branch_exists_and(word) { |node, sliced_word| node.has_branch_for?(sliced_word) }
    end

    def as_word
      raise InvalidTrieOperation.new() unless @letter.nil? or terminal?
      get_letter_string
    end

    def is_word?(word)
      return true if word.empty? and terminal?
      branch_exists_and(word) { |node, sliced_word| node.is_word?(sliced_word) }
    end

    protected
    def get_letter_string
      if @parent.nil?
        @letter.to_s or ''
      else
        @parent.get_letter_string + @letter.to_s
      end
    end

    def parent=(parent)
      @parent = parent
    end

    private

    def branch_exists_and(word, &block)
      first_letter = word.slice!(0)

      unless first_letter.nil?
        first_letter = first_letter.to_sym
        return block.call(@children[first_letter], word) if @children.has_key?(first_letter)
      end

      false
    end
  end
end
