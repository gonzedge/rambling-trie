module Rambling
  module Trie
    module Configuration
      # Collection of configurable providers.
      class ProviderCollection
        extend ::Forwardable

        # The name of this provider collection.
        # @return [String] the name of this provider collection.
        attr_reader :name

        # @overload default
        #   The default provider. Used when a provider cannot be resolved in
        #   {ProviderCollection#resolve #resolve}.
        # @overload default=(provider)
        #   Sets the default provider. Needs to be one of the configured
        #   providers.
        #   @param [Object] provider the provider to use as default.
        #   @raise [ArgumentError] when the given provider is not in the
        #     provider collection.
        #   @note If no providers have been configured, `nil` will be assigned.
        # @return [Object, nil] the default provider to use when a provider
        #   cannot be resolved in {ProviderCollection#resolve #resolve}.
        attr_reader :default

        delegate [
          :[],
          :[]=,
          :keys,
          :values,
        ] => :providers

        # Creates a new provider collection.
        # @param [String] name the name for this provider collection.
        # @param [Hash] providers the configured providers.
        # @param [Object] default the configured default provider.
        def initialize name, providers = {}, default = nil
          @name = name
          @configured_providers = providers
          @configured_default = default || providers.values.first

          reset
        end

        # Adds a new provider to the provider collection.
        # @param [Symbol] extension the extension that the provider will
        #   correspond to.
        # @param [provider] provider the provider to add to the provider
        #   collection.
        def add extension, provider
          providers[extension] = provider
        end

        def default= provider
          unless contains? provider
            raise ArgumentError, "default #{name} should be part of configured #{name}s"
          end

          @default = provider
        end

        # List of configured providers.
        # @return [Hash] the mapping of extensions to their corresponding
        #   providers.
        def providers
          @providers ||= {}
        end

        # Resolves the provider from a filepath based on the file extension.
        # @param [String] filepath the filepath to resolve into a provider.
        # @return [Object] the provider corresponding to the file extension in
        #   this provider collection. {#default} if not found.
        def resolve filepath
          providers[format filepath] || default
        end

        # Resets the provider collection to the initial values.
        def reset
          providers.clear
          configured_providers.each { |k, v| providers[k] = v }
          self.default = configured_default
        end

        private

        attr_reader :configured_providers, :configured_default

        def format filepath
          format = File.extname filepath
          format.slice! 0
          format.to_sym
        end

        def contains? provider
          provider.nil? ||
            (providers.any? && providers.values.include?(provider))
        end
      end
    end
  end
end
