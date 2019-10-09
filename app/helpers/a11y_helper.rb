# Accessibilty aka a11y helpers
module A11yHelper
  def icon(type, label = nil, opts = {})
    attrs = { type: type, label: label }.merge(opts)

    FontAwesomeIconWidget.labelled(attrs).render(self)
  end

  def graphical_icon(type, opts = {})
    attrs = { type: type, label: nil }.merge(opts)

    FontAwesomeIconWidget.graphical(attrs).render(self)
  end

  def graphical_image(source, options = {})
    image source, '', options
  end

  def image(source, alt, options = {})
    image_tag source, { alt: alt }.merge(options)
  end
end
