# Accessibilty aka a11y helpers
module A11yHelper
  def icon(type, label = nil)
    content_tag :i, '', class: "fa fa-#{type}", 'aria-label': (label || type)
  end

  def graphical_icon(type)
    content_tag :i, '', class: "fa fa-#{type}", 'aria-hidden': true
  end

  def graphical_image(source, options = {})
    image_tag source, { alt: '' }.merge(options)
  end
end
