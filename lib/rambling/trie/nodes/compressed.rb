# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a node in an compressed trie data structure.
      class Compressed < Rambling::Trie::Nodes::Node
        # Always raises {Rambling::Trie::InvalidOperation InvalidOperation} when
        # trying to add a word to the current compressed trie node
        # @param [String] _ the word to add to the trie.
        # @raise [InvalidOperation] if the trie is already compressed.
        # @return [nil] this never returns as it always raises an exception.
        def add _
          raise Rambling::Trie::InvalidOperation,
            'Cannot add word to compressed trie'
        end

        # Checks if a path for set a of characters exists in the trie.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Boolean] `true` if the characters are found, `false`
        #   otherwise.
        def partial_word? chars
          chars.empty? || partial_word_chars?(chars)
        end

        # Checks if a path for set of characters represents a word in the trie.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Boolean] `true` if the characters are found and form a word,
        #   `false` otherwise.
        def word? chars
          chars.empty? ? terminal? : word_chars?(chars)
        end

        # Always return `true` for a compressed node.
        # @return [Boolean] always `true` for a compressed node.
        def compressed?
          true
        end

        private

        def partial_word_chars? chars
          recursive_get(:partial_word?, chars) || false
        end

        def word_chars? chars
          current_key = nil

          until chars.empty?
            if current_key
              current_key << chars.slice!(0)
            else
              current_key = chars.slice!(0)
            end

            child = children_tree[current_key.to_sym]
            return child.word? chars if child
          end

          false
        end

        def closest_node chars
          recursive_get(:scan, chars) || Rambling::Trie::Nodes::Missing.new
        end

        def children_match_prefix chars
          return enum_for :children_match_prefix, chars unless block_given?

          current_key = nil

          until chars.empty?
            if current_key
              current_key << chars.slice!(0)
            else
              current_key = chars.slice!(0)
            end

            child = children_tree[current_key.to_sym]

            next unless child

            child.match_prefix chars do |word|
              yield word
            end
          end
        end

        def recursive_get method, chars
          current_length = 0
          current_key = current_key chars.slice!(0)

          loop do
            current_length += 1
            same_length = current_key && current_key.length == current_length

            if current_key && (same_length || chars.empty?)
              return children_tree[current_key.to_sym].send method, chars
            end

            contains_key = nil

            if current_key
              contains_key = current_key[current_length] == chars.slice!(0)
            end
            break unless contains_key
          end
        end

        def current_key letter
          current_key = nil

          children_tree.each_key do |letters|
            letters_string = letters.to_s

            if letters_string.start_with? letter
              current_key = letters_string
              break
            end
          end

          current_key
        end
      end
    end
  end
end
