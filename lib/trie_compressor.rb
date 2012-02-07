module Rambling
  module TrieCompressor
    def compress!
      if @children.size == 1 and not terminal?
        transfer_ownership_from(@children.values.first)
        compress!
      end

      @children.values.each { |node| node.compress! }

      self
    end

    private

    def transfer_ownership_from(child)
      @parent.delete(@letter) unless @parent.nil?
      @letter = (@letter.to_s + child.letter.to_s).to_sym
      @parent[@letter] = self unless @parent.nil?

      @children = child.children
      @is_terminal = child.terminal?
      @children.values.each { |node| node.parent = self }
    end
  end
end
