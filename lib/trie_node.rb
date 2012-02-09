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

    def add_branch_from(word)
      return if word.empty?

      first_letter = word.slice(0).to_sym

      if @children.has_key?(first_letter)
        word.slice!(0)
        @children[first_letter].add_branch_from(word)
      else
        @children[first_letter] = TrieNode.new(word, self)
      end
    end

    def has_branch_for?(word)
      word.empty? or branch_exists_and(word, :has_branch_for?)
    end

    def as_word
      raise InvalidTrieOperation.new() unless @letter.nil? or terminal?
      get_letter_string
    end

    def is_word?(word = '')
      (word.empty? and terminal?) or branch_exists_and(word, :is_word?)
    end

    protected
    def get_letter_string
      (@parent.nil? ? '' : @parent.get_letter_string) + @letter.to_s
    end

    def parent=(parent)
      @parent = parent
    end

    private

    def branch_exists_and(word, method)
      first_letter = word.slice!(0)

      return false if first_letter.nil?

      first_letter_key = first_letter.to_sym
      @children.has_key?(first_letter_key) ? @children[first_letter_key].send(method, word) : false
    end
  end
end
