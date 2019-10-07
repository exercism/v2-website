# Accessibilty aka a11y helpers
module A11yHelper
  def icon(type, label = nil, style: :normal, fixed_width: false)
    base_class = font_awesome_class(style, fixed_width)

    content_tag :i, '', class: "#{base_class} fa-#{type}", 'aria-label': (label || type)
  end

  def graphical_icon(type, style: :normal, fixed_width: false)
    base_class = font_awesome_class(style, fixed_width)

    content_tag :i, '', class: "#{base_class} fa-#{type}", 'aria-hidden': true
  end

  def graphical_image(source, options = {})
    image source, '', options
  end

  def image(source, alt, options = {})
    image_tag source, { alt: alt }.merge(options)
  end

  private

  def font_awesome_class(style)
    style_class = case style
                  when :normal
                    "fa"
                  when :light
                    "fal"
                  end
    fixed_width_class = fixed_width ? "fa-fw" : ""

    [style_class, fixed_width_class].join(" ")
  end
end
