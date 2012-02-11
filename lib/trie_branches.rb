module Rambling
  module TrieBranches
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

    protected

    def has_uncompressed_branch_for?(word = '')
      word.empty? or fulfills_uncompressed_condition?(:has_uncompressed_branch_for?, word)
    end

    def fulfills_uncompressed_condition?(method, word)
      clone = word.clone
      first_letter = clone.slice!(0)
      unless first_letter.nil?
        first_letter_sym = first_letter.to_sym
        return @children[first_letter_sym].send(method, clone) if @children.has_key?(first_letter_sym)
      end

      false
    end

    def has_compressed_branch_for?(word = '')
      return true if word.empty?

      keys = @children.keys.map { |x| x.to_s }
      return true if keys.include?(word)

      partial_key = keys.select { |x| x.start_with?(word) }.first
      return true unless partial_key.nil?

      key = keys.select { |x| word.start_with?(x) }.first
      return @children[key.to_sym].has_compressed_branch_for?(word.slice(key.length..word.length)) unless key.nil?

      false
    end

    def is_uncompressed_word?(word = '')
      (word.empty? and terminal?) or fulfills_uncompressed_condition?(:is_uncompressed_word?, word)
    end

    def is_compressed_word?(word = '')
      return true if word.empty? and terminal?

      length = word.length
      for index in (0...length)
        key = word.slice(0..index).to_sym
        return @children[key].is_compressed_word?(word.slice((index + 1)...length)) if @children.has_key?(key)
      end

      false
    end
  end
end
