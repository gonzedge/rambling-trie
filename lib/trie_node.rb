class TrieNode
  attr_reader :letter, :children

  def initialize(word)
    @children = {}
    word = word.clone

    unless word.nil?
      @letter = word.slice!(0)
      @is_terminal = word.empty?
      add_child(word)
    else
      @letter = ''
      @is_terminal = false
    end

  end

  def terminal=(terminal)
    @is_terminal = terminal
  end

  def terminal?
    @is_terminal
  end

  def add_child(word)
    first_letter = word.slice(0)
    unless terminal? or @children.has_key?(first_letter)
      @children[first_letter] = TrieNode.new(word)
    end
  end

  def has_child?(word)
    return true if word.empty?

    word = word.clone
    first_letter = word.slice!(0)

    return @children[first_letter].has_child?(word) if @children.has_key?(first_letter)
    false
  end
end
