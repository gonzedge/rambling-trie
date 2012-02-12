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

    def has_uncompressed_branch_for?(chars)
      chars.empty? or fulfills_uncompressed_condition?(:has_uncompressed_branch_for?, chars)
    end

    def has_compressed_branch_for?(chars)
      return true if chars.empty?

      length = chars.length
      first_letter = ''
      keys = @children.keys.map { |x| x.to_s }
      while not chars.empty?
        first_letter += chars.slice!(0)
        keys.delete_if { |x| not x.start_with?(first_letter) }

        break if keys.empty?
        return true if chars.empty?

        key = keys.first
        if key.length == first_letter.length
          key = key.to_sym
          return @children[key].has_compressed_branch_for?(chars) if @children.has_key?(key)
        end
      end

      false
    end

    def is_uncompressed_word?(chars)
      (chars.empty? and terminal?) or fulfills_uncompressed_condition?(:is_uncompressed_word?, chars)
    end

    def is_compressed_word?(chars)
      return true if chars.empty? and terminal?

      length = chars.length
      first_letter = ''
      while not chars.empty?
        first_letter += chars.slice!(0)
        key = first_letter.to_sym
        return @children[key].is_compressed_word?(chars) if @children.has_key?(key)
      end

      false
    end

    private

    def fulfills_uncompressed_condition?(method, chars)
      first_letter = chars.slice!(0)
      unless first_letter.nil?
        first_letter_sym = first_letter.to_sym
        return @children[first_letter_sym].send(method, chars) if @children.has_key?(first_letter_sym)
      end

      false
    end
  end
end
