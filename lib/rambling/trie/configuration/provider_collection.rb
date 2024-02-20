# frozen_string_literal: true

module Rambling
  module Trie
    module Configuration
      # Collection of configurable providers.
      class ProviderCollection
        # The name of this provider collection.
        # @return [Symbol] the name of this provider collection.
        attr_reader :name

        # @overload default
        #   The default provider. Used when a provider cannot be resolved in
        #   {ProviderCollection#resolve #resolve}.
        # @overload default=(provider)
        #   Sets the default provider. Needs to be one of the configured
        #   providers.
        #   @param [TProvider] provider the provider to use as default.
        #   @raise [ArgumentError] when the given provider is not in the provider collection.
        #   @note If no providers have been configured, +nil+ will be assigned.
        # @return [TProvider, nil] the default provider to use when a provider cannot be resolved in
        #   {ProviderCollection#resolve #resolve}.
        attr_reader :default

        # Creates a new provider collection.
        # @param [Symbol] name the name for this provider collection.
        # @param [Hash<Symbol, TProvider>] providers the configured providers.
        # @param [TProvider, nil] default the configured default provider.
        def initialize name, providers = {}, default = nil
          @name = name
          @configured_providers = providers
          @configured_default = default || providers.values.first

          reset
        end

        # Adds a new provider to the provider collection.
        # @param [Symbol] extension the extension that the provider will correspond to.
        # @param [TProvider] provider the provider to add to the provider collection.
        # @return [TProvider] the provider just added.
        def add extension, provider
          providers[extension] = provider
        end

        def default= provider
          raise ArgumentError, "default #{name} should be part of configured #{name}s" unless contains? provider

          @default = provider
        end

        # List of configured providers.
        # @return [Hash<Symbol, TProvider>] the mapping of extensions to their corresponding providers.
        def providers
          @providers ||= {}
        end

        # Resolves the provider from a filepath based on the file extension.
        # @param [String] filepath the filepath to resolve into a provider.
        # @return [TProvider, nil] the provider for the given file's extension. {#default} if not found.
        def resolve filepath
          providers[file_format filepath] || default
        end

        # Resets the provider collection to the initial values.
        # @return [void]
        def reset
          providers.clear
          configured_providers.each { |k, v| self[k] = v }
          self.default = configured_default
        end

        # Get provider corresponding to a given format.
        # @return [Array<Symbol>] the provider corresponding to that format.
        # @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-5B-5D
        #   Hash#keys
        def formats
          providers.keys
        end

        # Get provider corresponding to a given format.
        # @param [Symbol] format the format to search for in the collection.
        # @return [TProvider] the provider corresponding to that format.
        # @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-5B-5D Hash#[]
        def [] format
          providers[format]
        end

        private

        attr_reader :configured_providers, :configured_default

        def []= format, instance
          providers[format] = instance
        end

        def values
          providers.values
        end

        def file_format filepath
          format = File.extname filepath
          format.slice! 0
          format.to_sym
        end

        def contains? provider
          return true if provider.nil?
          p = (provider || raise)
          providers.any? && provider_instances.include?(p)
        end

        alias_method :provider_instances, :values
      end
    end
  end
end
