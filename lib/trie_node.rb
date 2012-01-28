class TrieNode
  attr_reader :letter, :children

  def initialize(word)
    @children = {}

    if word.nil?
      @letter = ''
      @is_terminal = false
    else
      @letter = word.slice!(0)
      @is_terminal = word.empty?
      add_branch_from(word)
    end

  end

  def terminal=(terminal)
    @is_terminal = terminal
  end

  def terminal?
    @is_terminal
  end

  def add_branch_from(word)
    first_letter = word.slice(0)

    unless terminal? or @children.has_key?(first_letter)
      @children[first_letter] = TrieNode.new(word)
    end
  end

  def has_child?(word)
    return true if word.empty?

    first_letter = word.slice!(0)

    return @children[first_letter].has_child?(word) if @children.has_key?(first_letter)
    false
  end
end
