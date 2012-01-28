class Trie < TrieNode
  def initialize(filename = nil)
    super(nil)
    @children.clear

    @filename = filename
    add_all_nodes if filename
  end

  private
  def add_all_nodes
    File.open(@filename) do |file|
      file.readlines.each { |line| add_child(line) }
    end
  end
end
