module Rambling
  module TrieBranches
    def has_branch_for?(word)
      return true if word.empty?

      keys = @children.keys.map { |x| x.to_s }
      return true if keys.include?(word)

      partial_key = keys.select { |x| x.start_with?(word) }.first
      return true unless partial_key.nil?

      key = keys.select { |x| word.start_with?(x) }.first
      return @children[key.to_sym].has_branch_for?(word.slice(key.length..word.length)) unless key.nil?

      false
    end

    def is_word?(word = '')
      return true if word.empty? and terminal?

      length = word.length
      for index in (0...length)
        key = word.slice(0..index).to_sym
        return @children[key].is_word?(word.slice((index + 1)...length)) if @children.has_key?(key)
      end

      false
    end

    def add_branch_from(word)
      raise InvalidTrieOperation.new('Cannot add branch to compressed trie') if compressed?
      if word.empty?
        @is_terminal = true
        return
      end

      first_letter = word.slice(0).to_sym

      if @children.has_key?(first_letter)
        word.slice!(0)
        @children[first_letter].add_branch_from(word)
      else
        @children[first_letter] = TrieNode.new(word, self)
      end
    end
  end
end
