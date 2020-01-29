class FontAwesomeIconWidget
  def self.graphical(attrs = {})
    new(attrs.merge(graphical: true))
  end

  def self.labelled(attrs = {})
    new(attrs.merge(graphical: false))
  end

  def initialize(type:, label:, style:, fixed_width: false, graphical:, extra_classes: "")
    @type = Array(type)
    @label = label
    @style = style
    @extra_classes = extra_classes
    @fixed_width = fixed_width
    @graphical = graphical
  end

  def render(context)
    context.content_tag :i, "", attributes
  end

  private
  attr_reader :type, :label, :style, :fixed_width, :graphical, :extra_classes

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
    fa_classes = [style_class, fixed_width_class, type_class].
                   reject(&:blank?).join(" ")
    "#{fa_classes} #{extra_classes}".strip
  end

  def style_class
    case style
    when :light
      "fal"
    when :solid
      "fas"
    when :regular
      "far"
    when :duotone
      "fad"
    when :brand
      "fab"
    else
      raise "Invalid font-awesome icon style"
    end
  end

  def fixed_width_class
    fixed_width ? "fa-fw" : ""
  end

  def type_class
    type.map { |type| "fa-#{type}" }
  end
end
