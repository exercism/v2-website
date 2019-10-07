module RuboCop
  module Cop
    module Custom
      class AccessibleImages < Cop
        MSG = 'Instead of `#image_tag`, replace with either #image or #graphical_image for a11y support.'

        def_node_matcher :bad_method?, <<~PATTERN
          (send nil? :image_tag ...)
        PATTERN

        def on_send(node)
          return unless bad_method?(node)

          add_offense(node)
        end
      end
    end
  end
end
