# module Rambling
#   module Trie
#     # Provides delegation behavior.
#     module Forwardable
#       # Custom delegation behavior due to Ruby 2.4 delegation performance
#       # degradation. See {https://bugs.ruby-lang.org/issues/13111 Bug #13111}.
#       # @param [Hash] methods_to_target a Hash consisting of the methods to be
#       #   delegated and the target to delegate those methods to.
#       # @return [Hash] the `methods_to_target` parameter.
#       def delegate methods_to_target
#         methods_to_target.each do |methods, target|
#           methods.each do |method|
#             define_method method do |*args|
#               send(target).send method, *args
#             end
#           end
#         end
#       end
#     end
#   end
# end
