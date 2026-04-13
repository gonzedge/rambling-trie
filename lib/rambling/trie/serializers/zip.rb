# frozen_string_literal: true

module Rambling
  module Trie
    module Serializers
      # Zip file serializer. Dumps/loads contents from `.zip` files.
      # Automatically detects if zip file contains a `.marshal` or `.yml` file,
      # or any other registered `:format => serializer` combo.
      class Zip < Serializer
        # Creates a new Zip serializer.
        # @param [Configuration::Properties] properties the configuration
        #   properties set up so far.
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

          # @type var cleanup_paths: Array[String]
          cleanup_paths = []

          ::Zip::File.open filepath do |zip|
            entry = zip.entries.first
            raise unless entry

            entry_name = entry.name
            entry_path = path entry_name
            cleanup_paths << entry_path

            entry.extract ::File.basename(entry_path), destination_directory: tmp_path
            (serializers.resolve(entry_name) || raise).load entry_path
          ensure
            cleanup_paths.each { |path| ::FileUtils.rm_f path }
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

          # @type var cleanup_paths: Array[String]
          cleanup_paths = []

          begin
            ::Zip::File.open filepath, create: true do |zip|
              filename = ::File.basename filepath, '.zip'

              entry_path = path filename
              cleanup_paths << entry_path

              (serializers.resolve(filename) || raise).dump contents, entry_path
              zip.add filename, entry_path
            end
          ensure
            cleanup_paths.each { |path| ::FileUtils.rm_f path }
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
