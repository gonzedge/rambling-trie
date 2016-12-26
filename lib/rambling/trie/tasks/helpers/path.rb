module Helpers
  module Path
    def path *filename
      Pathname.new(full_path *filename).cleanpath
    end

    def dictionary
      path 'assets', 'dictionaries', 'words_with_friends.txt'
    end

    private

    def full_path *filename
      full_path = File.join File.dirname(__FILE__), '..', '..', '..', '..', '..', *filename
    end
  end
end
