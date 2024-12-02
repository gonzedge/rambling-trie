# frozen_string_literal: true

require 'pathname'

module Helpers
  module Path
    def path *filename_pieces
      Pathname.new(full_path(*filename_pieces)).cleanpath
    end

    def dictionary
      File.join dictionaries_path, 'words_with_friends.txt'
    end

    def dictionaries_path
      path 'assets', 'dictionaries'
    end

    def tries_path
      path 'tmp', 'tries'
    end

    def raw_trie_path
      File.join tries_path, 'words_with_friends_raw.marshal'
    end

    def compressed_trie_path
      File.join tries_path, 'words_with_friends_compressed.marshal'
    end

    private

    def full_path *filename_pieces
      File.join File.dirname(__FILE__), '..', '..', *filename_pieces
    end
  end
end
