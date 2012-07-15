module Rambling
  module Trie
    # Provides the compressing behavior for the Trie data structure.
    module Compressor
      # Flag for compressed tries.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        @parent.nil? ? false : @parent.compressed?
      end

      protected

      def compress_own_tree!
        if @children.size == 1 and not terminal? and not @letter.nil?
          merge_with!(@children.values.first)
          compress_own_tree!
        end

        @children.values.each { |node| node.compress_own_tree! }

        self
      end

      private

      def merge_with!(child)
        new_letter = (@letter.to_s + child.letter.to_s).to_sym

        rehash_on_parent!(@letter, new_letter)
        redefine_self!(new_letter, child)

        @children.values.each { |node| node.parent = self }
      end

      def rehash_on_parent!(old_letter, new_letter)
        return if @parent.nil?

        @parent.delete(old_letter)
        @parent[new_letter] = self
      end

      def redefine_self!(new_letter, merged_node)
        @letter = new_letter
        @children = merged_node.children
        @is_terminal = merged_node.terminal?
      end
    end
  end
end
