module Rambling
  module Trie
    # Provides the branching behavior for the Trie data structure.
    module Branches
      # Adds a branch to the current trie node based on the word
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @note This method clears the contents of the word variable.
      def add(word)
        raise InvalidOperation, 'Cannot add branch to compressed trie' if compressed?
        if word.empty?
          self.terminal = true
          return
        end

        first_letter = word.slice(0).to_sym

        if children_tree.has_key? first_letter
          word.slice! 0
          child = children_tree[first_letter]
          child << word
          child
        else
          children_tree[first_letter] = Node.new word, self
        end
      end

      alias_method :<<, :add

      protected

      def branch_when_uncompressed?(chars)
        chars.empty? || fulfills_uncompressed_condition?(:branch_when_uncompressed?, chars)
      end

      def branch_when_compressed?(chars)
        chars.empty? || compressed_trie_has_branch?(chars)
      end

      def word_when_uncompressed?(chars)
        (chars.empty? && terminal?) || fulfills_uncompressed_condition?(:word_when_uncompressed?, chars)
      end

      def word_when_compressed?(chars)
        return true if chars.empty? && terminal?

        first_letter = ''
        while not chars.empty?
          first_letter << chars.slice!(0)
          key = first_letter.to_sym
          return children_tree[key].word_when_compressed?(chars) if children_tree.has_key? key
        end

        false
      end

      private

      def compressed_trie_has_branch?(chars)
        current_length = 0
        current_key, current_key_string = current_key chars.slice!(0)

        begin
          current_length += 1

          if current_key_string.length == current_length || chars.empty?
            return children_tree[current_key].branch_when_compressed?(chars)
          end
        end while current_key_string[current_length] == chars.slice!(0)
        false
      end

      def current_key(letter)
        current_key_string = current_key = nil

        children_tree.keys.each do |key|
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
          return children_tree[first_letter_sym].send(method, chars) if children_tree.has_key? first_letter_sym
        end

        false
      end
    end
  end
end
