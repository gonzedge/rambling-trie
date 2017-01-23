module Performance
  class Report
    attr_reader :output

    def initialize output = $stdout.dup
      @output = output
    end

    def start name
      output.puts
      output.puts "#{name} for rambling-trie version #{Rambling::Trie::VERSION}"
      output.puts
    end

    def finish
      output.close
    end
  end
end
