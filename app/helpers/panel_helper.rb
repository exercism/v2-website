module PanelHelper
  def render_panels(user = current_user, &block)
    options = { vertical_split: !user.try(&:full_width_code_panes?) }

    content_tag :div, capture(&block), class: panel_classes(options)
  end

  private

  def panel_classes(vertical_split:)
    classes = ["panels"]

    classes << "panels--vertical-split" if vertical_split

    classes.join(" ")
  end
end
