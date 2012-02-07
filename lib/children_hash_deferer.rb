module Rambling
  module ChildrenHashDeferer
    def [](key)
      @children[key]
    end

    def []=(key, value)
      @children[key] = value
    end

    def delete(key)
      @children.delete(key)
    end

    def has_key?(key)
      @children.has_key?(key)
    end
  end
end

