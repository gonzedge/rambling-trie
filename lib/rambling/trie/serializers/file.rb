# frozen_string_literal: true

module Rambling
  module Trie
    module Serializers
      # Basic file serializer. Dumps/loads string contents from files.
      class File
        # Loads contents from a specified filepath.
        # @param [String] filepath the filepath to load contents from.
        # @return [String] all contents of the file.
        def load filepath
          ::File.read filepath
        end

        # Dumps contents into a specified filepath.
        # @param [String] contents the contents to dump.
        # @param [String] filepath the filepath to dump the contents to.
        # @return [Numeric] number of bytes written to disk.
        def dump contents, filepath
          ::File.open filepath, 'w+' do |f|
            f.write contents
          end
        end
      end
    end
  end
end
