module Rambling
  module Trie
    # Provides the branching behavior for the Trie data structure.
    module Branches
      # Adds a branch to the current trie node based on the word
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @note This method clears the contents of the word variable.
      def add word
        raise InvalidOperation, 'Cannot add branch to compressed trie' if compressed?
        if word.empty?
          self.terminal = true
        else
          add_to_children_tree word
        end
      end

      # Alias for #add
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see Branches#add
      def << word
        add word
      end

      protected

      def partial_word_when_uncompressed? chars
        chars.empty? || fulfills_uncompressed_condition?(:partial_word_when_uncompressed?, chars)
      end

      def partial_word_when_compressed? chars
        chars.empty? || compressed_trie_has_partial_word?(chars)
      end

      def word_when_uncompressed? chars
        if chars.empty?
          terminal?
        else
          fulfills_uncompressed_condition? :word_when_uncompressed?, chars
        end
      end

      def word_when_compressed? chars
        if chars.empty?
          terminal?
        else
          compressed_trie_has_word? chars
        end
      end

      private

      def add_to_children_tree word
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

      def compressed_trie_has_partial_word? chars
        current_length = 0
        current_key, current_key_string = current_key chars.slice!(0)

        begin
          current_length += 1

          if current_key_string.length == current_length || chars.empty?
            return children_tree[current_key].partial_word_when_compressed? chars
          end
        end while current_key_string[current_length] == chars.slice!(0)

        false
      end

      def compressed_trie_has_word? chars
        current_key_string = ''

        while !chars.empty?
          current_key_string << chars.slice!(0)
          current_key = current_key_string.to_sym
          return children_tree[current_key].word_when_compressed? chars if children_tree.has_key? current_key
        end

        false
      end

      def current_key letter
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

      def fulfills_uncompressed_condition? method, chars
        first_letter_sym = chars.slice!(0).to_sym
        children_tree.has_key?(first_letter_sym) && children_tree[first_letter_sym].send(method, chars)
      end
    end
  end
end
