require "byebug"

module HamlLint
  class Linter::AccessibleIcons < Linter
    include LinterRegistry

    MSG = "Replace icon with either `#icon` or `#graphical_icon` for a11y support."

    def visit_tag(node)
      return unless node.tag_name == "i"

      if node.static_classes.flatten.any? { |html_class| font_awesome?(html_class) }
        record_lint(node, MSG)
      end
    end

    private

    def font_awesome?(html_class)
      ["fab", "fas", "fa", "far", "fal"].include?(html_class)
    end
  end
end
