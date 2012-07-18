module Rambling
  module Trie
    # Provides the branching behavior for the Trie data structure.
    module Branches
      # Adds a branch to the trie based on the word.
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      def add_branch_from(word)
        raise InvalidOperation.new('Cannot add branch to compressed trie') if compressed?
        if word.empty?
          @is_terminal = true
          return
        end

        first_letter = word.slice(0).to_sym

        if @children.has_key?(first_letter)
          word.slice!(0)
          child = @children[first_letter]
          child.add_branch_from(word)
          child
        else
          @children[first_letter] = Node.new word, self
        end
      end

      protected

      def uncompressed_has_branch_for?(chars)
        chars.empty? or fulfills_uncompressed_condition?(:uncompressed_has_branch_for?, chars)
      end

      def compressed_has_branch_for?(chars)
        return true if chars.empty?

        first_letter = chars.slice!(0)
        key = nil
        @children.keys.each do |x|
          x = x.to_s
          if x.start_with?(first_letter)
            key = x
            break
          end
        end

        unless key.nil?
          sym_key = key.to_sym
          return @children[sym_key].compressed_has_branch_for?(chars) if key.length == first_letter.length

          while not chars.empty?
            char = chars.slice!(0)

            break unless key[first_letter.length] == char

            first_letter += char
            return true if chars.empty?
            return @children[sym_key].compressed_has_branch_for?(chars) if key.length == first_letter.length
          end
        end

        false
      end

      def uncompressed_is_word?(chars)
        (chars.empty? and terminal?) or fulfills_uncompressed_condition?(:uncompressed_is_word?, chars)
      end

      def compressed_is_word?(chars)
        return true if chars.empty? and terminal?

        first_letter = ''
        while not chars.empty?
          first_letter += chars.slice!(0)
          key = first_letter.to_sym
          return @children[key].compressed_is_word?(chars) if @children.has_key?(key)
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
end
