module Rambling
  module Trie
    module Compressed
      # A representation of a node in an compressed Trie data structure.
      class Node < Rambling::Trie::Node
        # Adds a branch to the current trie node based on the word
        # @param [String] word the word to add the branch from.
        # @return [Rambling::Trie::Compressed::Node] the just added branch's root node.
        # @note This method clears the contents of the word variable.
        def add word
          raise InvalidOperation, 'Cannot add branch to compressed trie'
        end

        def partial_word? chars
          chars.empty? || compressed_trie_has_partial_word?(chars)
        end

        def word? chars
          if chars.empty?
            terminal?
          else
            compressed_trie_has_word? chars
          end
        end

        def compressed?
          true
        end

        def letter= letter
          super
        end

        def terminal= terminal
          super
        end

        def children_tree= children_tree
          super
        end

        private

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
          current_key_string = current_key = ''

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
      end
    end
  end
end
