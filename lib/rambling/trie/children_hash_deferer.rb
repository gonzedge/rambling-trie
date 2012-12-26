module Rambling
  module Trie
    # Provides some proxy methods to the children's hash for readability.
    module ChildrenHashDeferer
      # Proxies to @children[key]
      # @param [Symbol] key the key to look for in the children's hash.
      # @return [Node, nil] the child node with that key or nil.
      def [](key)
        children[key]
      end

      # Proxies to @children[key] = value.
      # @param [Symbol] key the to add or change the value for.
      # @param [Node] value the node to add to the children's hash.
      # @return [Node, nil] the child node with that key or nil.
      def []=(key, value)
        children[key] = value
      end

      # Proxies to @children.delete(key)
      # @param [Symbol] key the key to delete in the children's hash.
      # @return [Node, nil] the child node corresponding to the key just deleted or nil.
      def delete(key)
        children.delete(key)
      end

      # Proxies to @children.has_key?(key)
      # @param [Symbol] key the key to look for in the children's hash.
      # @return [Boolean] `true` for the keys that exist in the children's hash, false otherwise.
      def has_key?(key)
        children.has_key?(key)
      end
    end
  end
end
