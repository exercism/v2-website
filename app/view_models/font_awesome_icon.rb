class FontAwesomeIcon
  def self.graphical(attrs = {})
    new(attrs.merge(graphical: true))
  end

  def self.labelled(attrs = {})
    new(attrs.merge(graphical: false))
  end

  def initialize(type:, label:, style:, fixed_width: false, graphical:)
    @type = type
    @label = label
    @style = style
    @fixed_width = fixed_width
    @graphical = graphical
  end

  def render(context)
    context.content_tag :i, "", attributes
  end

  private
  attr_reader :type, :label, :style, :fixed_width, :graphical

  def graphical?
    graphical
  end

  def attributes
    html_attributes.merge(aria_attributes)
    aria_attributes.merge({ class: html_class })
  end

  def html_attributes
    { class: html_class }
  end

  def aria_attributes
    if graphical?
      { "aria-hidden": true }
    else
      { "aria-label": (label || type) }
    end
  end

  def aria_label
    label || type
  end

  def html_class
    [style_class, fixed_width_class, type_class].reject(&:blank?).join(" ")
  end

  def style_class
    case style
    when :legacy
      "fa"
    when :light
      "fal"
    end
  end

  def fixed_width_class
    fixed_width ? "fa-fw" : ""
  end

  def type_class
    "fa-#{type}"
  end
end
