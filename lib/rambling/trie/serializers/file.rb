module Rambling
  module Trie
    module Serializers
      # Basic file reader/writer
      class File
        def load filepath
          ::File.read filepath
        end

        def dump contents, filepath
          ::File.open filepath, 'w+' do |f|
            f.write contents
          end
        end
      end
    end
  end
end
