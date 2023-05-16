# frozen_string_literal: true

module Rambling
  module Trie
    module Serializers
      # Zip file serializer. Dumps/loads contents from +.zip+ files.
      # Automatically detects if zip file contains a +.marshal+ or +.yml+ file,
      # or any other registered +:format => serializer+ combo.
      # :reek:TooManyStatements { max_statements: 10 }
      class Zip < Serializer
        # Creates a new Zip serializer.
        # @param [Configuration::Properties] properties the configuration
        #   properties set up so far.
        # :reek:ControlParameter
        def initialize properties
          super()
          @properties = properties
        end

        # Unzip contents from specified filepath and load in contents from
        # unzipped files.
        # @param [String] filepath the filepath to load contents from.
        # @return [TContents] all contents of the unzipped loaded file.
        # @see https://github.com/rubyzip/rubyzip#reading-a-zip-file Zip
        #   reading a file
        def load filepath
          require 'zip'

          ::Zip::File.open filepath do |zip|
            entry = zip.entries.first
            entry_path = path entry.name
            entry.extract entry_path

            serializer = serializers.resolve entry.name
            serializer.load entry_path
          end
        end

        # Dumps contents and zips into a specified filepath.
        # @param [String] contents the contents to dump.
        # @param [String] filepath the filepath to dump the contents to.
        # @return [TContents] number of bytes written to disk.
        # @see https://github.com/rubyzip/rubyzip#basic-zip-archive-creation
        #   Zip archive creation
        def dump contents, filepath
          require 'zip'

          ::Zip::File.open filepath, ::Zip::File::CREATE do |zip|
            filename = ::File.basename filepath, '.zip'

            entry_path = path filename
            serializer = serializers.resolve filename
            serializer.dump contents, entry_path

            zip.add filename, entry_path
          end

          ::File.size filepath
        end

        private

        attr_reader :properties

        def serializers
          properties.serializers
        end

        def tmp_path
          properties.tmp_path
        end

        def path filename
          require 'securerandom'
          ::File.join tmp_path, "#{SecureRandom.uuid}-#{filename}"
        end
      end
    end
  end
end
