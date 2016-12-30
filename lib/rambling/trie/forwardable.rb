module Rambling
  module Trie
    # Provides delegation behavior
    module Forwardable
      class << self
        def extended mod
          def mod.delegate delegated_methods_to_delegated_to
            delegated_methods_to_delegated_to.each do |methods, delegated_to|
              methods.each do |method|
                define_method method do |*args|
                  send(delegated_to).send method, *args
                end
              end
            end
          end
        end
      end
    end
  end
end
