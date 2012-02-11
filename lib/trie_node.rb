module Rambling
  class TrieNode
    include ChildrenHashDeferer
    include TrieCompressor
    include TrieBranches

    attr_reader :letter, :children, :parent

    def initialize(word, parent = nil)
      @letter = nil
      @parent = parent
      @is_terminal = false
      @children = {}

      unless word.nil? or word.empty?
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

    def as_word
      raise InvalidTrieOperation.new() unless @letter.nil? or terminal?
      get_letter_string
    end

    protected
    def get_letter_string
      (@parent.nil? ? '' : @parent.get_letter_string) + @letter.to_s
    end

    def parent=(parent)
      @parent = parent
    end
  end
end
