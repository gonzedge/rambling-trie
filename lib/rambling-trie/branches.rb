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

        if @children.has_key? first_letter
          word.slice! 0
          child = @children[first_letter]
          child << word
          child
        else
          @children[first_letter] = Node.new word, self
        end
      end

      alias_method :<<, :add_branch_from

      protected

      def uncompressed_has_branch_for?(chars)
        chars.empty? or fulfills_uncompressed_condition?(:uncompressed_has_branch_for?, chars)
      end

      def compressed_has_branch_for?(chars)
        return true if chars.empty?

        first_letter = chars.slice! 0
        current_key, current_key_string = current_key first_letter

        unless current_key.nil?
          return @children[current_key].compressed_has_branch_for?(chars) if current_key_string.length == first_letter.length

          while not chars.empty?
            char = chars.slice! 0

            break unless current_key_string[first_letter.length] == char

            first_letter += char
            return true if chars.empty?
            return @children[current_key].compressed_has_branch_for?(chars) if current_key_string.length == first_letter.length
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
          first_letter += chars.slice! 0
          key = first_letter.to_sym
          return @children[key].compressed_is_word?(chars) if @children.has_key? key
        end

        false
      end

      private

      def current_key(letter)
        current_key_string = current_key = nil

        @children.keys.each do |key|
          key_string = key.to_s
          if key_string.start_with? letter
            current_key = key
            current_key_string = key_string
            break
          end
        end

        [current_key, current_key_string]
      end

      def fulfills_uncompressed_condition?(method, chars)
        first_letter = chars.slice! 0
        unless first_letter.nil?
          first_letter_sym = first_letter.to_sym
          return @children[first_letter_sym].send(method, chars) if @children.has_key?(first_letter_sym)
        end

        false
      end
    end
  end
end
